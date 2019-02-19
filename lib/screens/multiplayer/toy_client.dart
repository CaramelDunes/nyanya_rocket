import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:nyanya_rocket/screens/multiplayer/toy_server.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class ToyClient {
  final String serverHostname;
  final int port;
  final String nickname;

  RawDatagramSocket _socket;
  final List<String> _players = List.filled(4, '');
  final StreamController<Game> gameStream = StreamController();
  final StreamController<Duration> timeStream = StreamController();
  final List<StreamController<int>> scoreStreams =
      List.generate(4, (_) => StreamController(), growable: false);

  final BytesBuilder _builder = BytesBuilder();

  InternetAddress _serverAddress;

  int _timestamp = 0;

  ToyClient({
    @required this.serverHostname,
    @required this.nickname,
    this.port = 43210,
  }) {
    InternetAddress.lookup(serverHostname)
        .then((List<InternetAddress> addresses) {
      if (addresses.length > 0) {
        _serverAddress = addresses[0];

        RawDatagramSocket.bind(InternetAddress.anyIPv4, 0)
            .then((RawDatagramSocket socket) {
          _socket = socket;
          _socket.listen(_handleSocketEvent);

          _builder.addByte(MessageTypes.Login.index);
          _builder
              .add((RegisterMessage()..nickname = nickname).writeToBuffer());
          _socket.send(_builder.takeBytes(), _serverAddress, port);
        });
      }
    });
  }

  void close() {
    _socket?.close();

    gameStream.close();
    timeStream.close();
    scoreStreams.forEach((StreamController stream) => stream.close());
  }

  List<String> get players => _players;

  void placeArrow(int x, int y, Direction direction) {
    if (_socket != null) {
      PlaceArrowMessage msg = PlaceArrowMessage()
        ..x = x
        ..y = y
        ..direction = ProtocolDirection.values[direction.index];

      _builder.addByte(MessageTypes.PlaceArrow.index);
      _builder.add(msg.writeToBuffer());
      _socket.send(_builder.takeBytes(), _serverAddress, port);
    }
  }

  void _handleSocketEvent(RawSocketEvent event) {
    if (event == RawSocketEvent.read) {
      Datagram datagram = _socket.receive();
      if (datagram != null) {
        var buffer = datagram.data;

        if (datagram.data.length > 0) {
          if (datagram.data[0] == MessageTypes.GameState.index) {
            buffer = buffer.getRange(1, buffer.length).toList();

            ProtocolGame g = ProtocolGame.fromBuffer(buffer);

            if (_timestamp < g.timestamp) {
              gameStream.add(Game.fromProtocolGame(g));
              _timestamp = g.timestamp;
              timeStream.add(Duration(milliseconds: _timestamp * 16));

              for (int i = 0; i < 4; i++) {
                scoreStreams[i].add(g.scores[i]);
              }
            }
          } else if (datagram.data[0] == MessageTypes.LoginSuccess.index) {
            buffer = buffer.getRange(1, buffer.length).toList();

            RegisterSuccessMessage msg =
                RegisterSuccessMessage.fromBuffer(buffer);
            _players[msg.givenColor.value] = msg.nickname;

            scoreStreams
                .forEach((StreamController scoreStream) => scoreStream.add(0));
          }
        }
      }
    }
  }
}
