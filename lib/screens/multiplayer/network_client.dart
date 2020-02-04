import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class NetworkClient extends GameTicker {
  ClientSocket _socket;
  final List<String> _players = List.filled(4, '');
  final ValueNotifier<Game> gameStream = ValueNotifier(Game());
  final StreamController<Duration> timeStream = StreamController();
  final List<StreamController<int>> scoreStreams =
      List.generate(4, (_) => StreamController(), growable: false);

  int _timestamp = 0;

  GameEvent _previousEvent = GameEvent.None;
  final void Function(GameEvent event) onGameEvent;

  NetworkClient(
      {@required InternetAddress serverAddress,
      @required String nickname,
      int port = 43122,
      this.onGameEvent})
      : super(Game()) {

    print('Connecting to $serverAddress:$port');
    _socket = ClientSocket(
        serverAddress: serverAddress,
        port: port,
        gameCallback: _handleGame,
        nickname: nickname,
        playerRegisterSuccessCallback: _handleRegisterSuccess);
  }

  void close() {
    super.close();

    _socket?.close();
    timeStream.close();
    scoreStreams.forEach((StreamController stream) => stream.close());
  }

  List<String> get players => _players;

  void placeArrow(int x, int y, Direction direction) {
    if (_socket != null) {
      _socket.sendArrowRequest(x, y, direction);
    }
  }

  void _handleGame(Game newGame) {
    if (onGameEvent != null &&
        newGame.currentEvent != GameEvent.None &&
        newGame.currentEvent != _previousEvent) {
      _previousEvent = newGame.currentEvent;
      onGameEvent(newGame.currentEvent);
    }

    _timestamp = newGame.tickCount;
    timeStream.add(Duration(milliseconds: _timestamp * 16));

    for (int i = 0; i < 4; i++) {
      scoreStreams[i].add(newGame.scoreOf(PlayerColor.values[i]));
    }

    if (game.tickCount <= newGame.tickCount) {
      game = newGame;
    } else {
      for (int i = 0; i < game.tickCount - newGame.tickCount; i++) {
        newGame.tick();
      }

      game = newGame;
    }

//    game.generatorPolicy = GeneratorPolicy.None;
    running = true;
  }

  @override
  void afterTick() {
    gameStream.value = game;
  }

  void _handleRegisterSuccess(RegisterSuccessMessage message) {
    _players[message.givenColor.value] = message.nickname;

    // Proc update of score boxes
    scoreStreams.forEach((StreamController scoreStream) => scoreStream.add(0));
  }
}
