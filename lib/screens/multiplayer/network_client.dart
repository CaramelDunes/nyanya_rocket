import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class NetworkClient extends MultiplayerGameTicker {
  ClientSocket _socket;
  final List<String> _players = List.filled(4, '');
  final ValueNotifier<GameState> gameStream = ValueNotifier(GameState());
  final StreamController<Duration> timeStream = StreamController();
  final List<StreamController<int>> scoreStreams =
      List.generate(4, (_) => StreamController(), growable: false);

  int _timestamp = 0;

  GameEvent _previousEvent = GameEvent.None;
  final void Function(GameEvent event) onGameEvent;
  PlayerColor assignedColor;

  NetworkClient(
      {@required InternetAddress serverAddress,
      @required String nickname,
      int port = 43122,
      int ticket,
      this.onGameEvent})
      : super(MultiplayerGameState()) {
    print('Connecting to $serverAddress:$port using ticket $ticket');
    _socket = ClientSocket(
        serverAddress: serverAddress,
        serverPort: port,
        gameStateCallback: _handleGame,
        nickname: nickname,
        ticket: ticket,
        playerRegisterSuccessCallback: _handleRegisterSuccess,
        playerNicknamesCallback: _handlePlayerNicknames);
  }

  void close() {
    _socket?.close();
    timeStream.close();
    scoreStreams.forEach((StreamController stream) => stream.close());

    super.close();
  }

  List<String> get players => _players;

  @override
  bool placeArrow(int x, int y, PlayerColor player, Direction direction) {
    if (_socket != null) {
      _socket.sendArrowRequest(x, y, direction);
    }

    return true;
  }

  void _handleGame(MultiplayerGameState newGame) {
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
      gameState = newGame;
    } else {
      int catchingUp = game.tickCount - newGame.tickCount;
      for (int i = 0; i < catchingUp; i++) {
        gameSimulator.tick(game);
      }

      gameState = newGame;
    }

    running = true;
  }

  @override
  void afterTick() {
    super.afterTick();

    gameStream.value = game;
  }

  void _handleRegisterSuccess(PlayerColor assignedColor) {
    this.assignedColor = assignedColor;

    // Proc update of score boxes
    scoreStreams.forEach((StreamController scoreStream) => scoreStream.add(0));
  }

  void _handlePlayerNicknames(List<String> nicknames) {
    if (nicknames.length != 4) {
      print('Got ${nicknames.length} nicknames!');
    }

    for (int i = 0; i < nicknames.length; i++) {
      _players[i] = nicknames[i];
      scoreStreams[i].add(game.scoreOf(PlayerColor.values[i]));
    }
  }
}
