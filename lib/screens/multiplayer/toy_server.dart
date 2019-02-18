import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:nyanya_rocket/blocs/local_game_controller.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class ArrowPosition {
  final int x;
  final int y;

  ArrowPosition(this.x, this.y);
}

class PlayerKey {
  final InternetAddress address;
  final int port;

  PlayerKey(this.address, this.port);

  @override
  bool operator ==(dynamic other) =>
      other.port == port && other.address.toString() == address.toString();

  @override
  int get hashCode {
    return port + address.toString().hashCode << 16;
  }
}

class PlayerValue {
  final String name;
  final PlayerColor color;

  PlayerValue({this.name, this.color});
}

enum MessageTypes {
  Login, // Type - NameLength<16 - Name
  LoginSuccess, // Type - ColorIndex
  GameState, // Type - TimestampInMilliseconds
  PlaceArrow, // Type - x - y - direction index
}

class ToyServer extends LocalGameController {
  final int nbPlayer;

  RawDatagramSocket _socket;
  HashMap<PlayerKey, PlayerValue> _players = HashMap();
  BytesBuilder _builder = BytesBuilder();
  int _timestamp = 0;

  ToyServer({@required Board board, @required this.nbPlayer})
      : super(Game()
          ..board = Board.fromJson(jsonDecode(
            '{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":1},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4, "direction":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,2,0,0,0,0,0,1,2],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,2],[2,0,0,0,0,0,0,1,0]]}',
          ))) {
    RawDatagramSocket.bind('0.0.0.0', 43210).then((RawDatagramSocket socket) {
      _socket = socket;
      _socket.listen(_handleSocketEvent);
      print('Bound to port 43210');
    }).catchError(() => print('Could not bind to port 43210'));

    running = false;
  }

  void close() {
    super.close();

    _socket?.close();
  }

  @override
  void afterTick() {
    ProtocolGame state = game.toGameState();
    state.timestamp = _timestamp++;
    _builder.addByte(MessageTypes.GameState.index);
    _builder.add(state.writeToBuffer());

    _players.forEach((PlayerKey key, PlayerValue value) =>
        _socket.send(_builder.toBytes(), key.address, key.port));

    _builder.clear();
  }

  void _handleSocketEvent(RawSocketEvent event) {
    if (event == RawSocketEvent.read) {
      Datagram received = _socket.receive();

      if (received != null) {
        _handleMessage(received);
      }
    }
  }

  void _handleMessage(Datagram packet) {
    List<int> buffer = packet.data;

    if (buffer.length == 0) {
      print('Received packet of size 0');
      return;
    }

    PlayerKey key = PlayerKey(packet.address, packet.port);
    PlayerValue player = _players.containsKey(key) ? _players[key] : null;

    switch (MessageTypes.values[buffer[0]]) {
      case MessageTypes.Login:
        if (player == null && _players.length < nbPlayer) {
          buffer = buffer.getRange(1, buffer.length).toList();
          RegisterMessage msg = RegisterMessage.fromBuffer(buffer);

          _players[key] = PlayerValue(
              name: msg.nickname, color: PlayerColor.values[_players.length]);

          print('New player ${msg.nickname}');

          _builder.addByte(MessageTypes.LoginSuccess.index);
          _builder.add((RegisterSuccessMessage()
                ..nickname = msg.nickname
                ..givenColor = _players[key].color.toProtocolPlayerColor())
              .writeToBuffer());
          _players.forEach((PlayerKey key, PlayerValue value) =>
              _socket.send(_builder.toBytes(), key.address, key.port));
          _builder.clear();

          if (_players.length <= nbPlayer) {
            // FIXME Debug condition
            running = true;
          }
        }
        break;

      case MessageTypes.PlaceArrow:
        if (player != null && running) {
          buffer = buffer.getRange(1, buffer.length).toList();
          PlaceArrowMessage msg = PlaceArrowMessage.fromBuffer(buffer);

          int x = msg.x;
          int y = msg.y;
          Direction direction = Direction.values[msg.direction.value];

          if (game.board.tiles[x][y] is Empty) {
            int count = 0;
            ArrowPosition last;
            int lastExpiration = Arrow.defaultExpiration;

            for (int i = 0; i < Board.width; i++) {
              // TODO Get rid of that ugly thing
              for (int j = 0; j < Board.height; j++) {
                if (game.board.tiles[i][j] is Arrow) {
                  Arrow arrow = game.board.tiles[i][j] as Arrow;
                  if (player.color == arrow.player) {
                    count++;

                    if (arrow.expiration < lastExpiration) {
                      last = ArrowPosition(i, j);
                      lastExpiration = arrow.expiration;
                    }
                  }
                }
              }
            }

            if (count >= 3) {
              game.board.tiles[last.x][last.y] = Empty();
            }

            game.board.tiles[x][y] =
                Arrow(player: player.color, direction: direction);
          }
        }
        break;

      default:
        break;
    }
  }
}
