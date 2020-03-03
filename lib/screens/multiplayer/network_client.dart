import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

enum NetworkGameStatus { ConnectingToServer, WaitingForPlayers, Playing, Ended }

class NetworkClient extends GameTicker<MultiplayerGameState> {
  ClientSocket _socket;
  final List<String> _players = List.filled(4, '');
  final ValueNotifier<GameState> gameStream = ValueNotifier(GameState());
  final ValueNotifier<Duration> timeStream = ValueNotifier(Duration.zero);
  final List<ValueNotifier<int>> scoreStreams =
      List.generate(4, (_) => ValueNotifier(0), growable: false);

  final void Function(GameEvent event) onGameEvent;
  final void Function(PlayerColor assignedColor) onRegisterSuccess;

  PlayerColor assignedColor;
  NetworkGameStatus _status = NetworkGameStatus.ConnectingToServer;

  NetworkClient(
      {@required InternetAddress serverAddress,
      @required String nickname,
      int port = 43122,
      int ticket,
      this.onGameEvent,
      this.onRegisterSuccess})
      : super(MultiplayerGameState(), MultiplayerGameSimulator()) {
    gameSimulator.onEntityInRocket = _handleEntityInRocket;

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

  NetworkGameStatus get status => _status;

  void close() {
    _socket?.close();
    timeStream.dispose();
    scoreStreams.forEach((ValueNotifier stream) => stream.dispose());

    super.close();
  }

  List<String> get players => _players;

  bool placeArrow(int x, int y, PlayerColor player, Direction direction) {
    if (_socket != null) {
      _socket.sendArrowRequest(x, y, direction);
    }

    return true;
  }

  void _mixGameEvents(
      MultiplayerGameState newGame, MultiplayerGameState afterCatchup) {
    if (onGameEvent != null &&
        newGame.currentEvent != GameEvent.None &&
        newGame.currentEvent != afterCatchup.currentEvent) {
      onGameEvent(newGame.currentEvent);
      print('Event Mix');
    }
  }

  void _handleGame(MultiplayerGameState newGame) {
    for (int i = 0; i < 4; i++) {
      scoreStreams[i].value = newGame.scoreOf(PlayerColor.values[i]);
    }

    // Local simulation is late or on time, just consume latest update.
    if (game.tickCount <= newGame.tickCount) {
      _mixGameEvents(newGame, game);
      if (game.tickCount == newGame.tickCount &&
          game.rng.state != newGame.rng.state) {
        print('rng?a');
      }

      if (game.tickCount < newGame.tickCount) {
        print('jump');
      }
      gameState = newGame;
    } else {
      // We are slightly early, align the server snapshot to our timeline.
      int catchingUp = game.tickCount - newGame.tickCount;

      print(catchingUp);

      // Only use our time frame if we are less than 2 second in advance on the server.
      if (catchingUp <= 2 * 2 * 60) {
        for (int i = 0; i < catchingUp; i++) {
          gameSimulator.microTick(newGame);
        }
      }

      _mixGameEvents(newGame, game);

      if (game.rng.state != newGame.rng.state) {
        print('rng?b');
      }

      gameState = newGame;
    }

    if (!running) {
      running = true;
      _status = NetworkGameStatus.Playing;
    }
  }

  @override
  void afterTick() {
    super.afterTick();

    gameStream.value = game;
    timeStream.value = Duration(milliseconds: game.tickCount * 8);
  }

  void _handleRegisterSuccess(PlayerColor assignedColor) {
    print('Register Success!');
    _status = NetworkGameStatus.WaitingForPlayers;

    if (onRegisterSuccess != null) {
      onRegisterSuccess(assignedColor);
    }

    this.assignedColor = assignedColor;

    // Proc update of score boxes
    scoreStreams.forEach((ValueNotifier scoreStream) => scoreStream.value = 0);
  }

  void _handlePlayerNicknames(List<String> nicknames) {
    if (nicknames.length != 4) {
      print('Got ${nicknames.length} nicknames!');
    }

    for (int i = 0; i < nicknames.length; i++) {
      _players[i] = nicknames[i];
      scoreStreams[i].value = game.scoreOf(PlayerColor.values[i]);
    }
  }

  void _handleEntityInRocket(Entity entity, int x, int y) {
    for (int i = 0; i < scoreStreams.length; i++) {
      scoreStreams[i].value = game.scoreOf(PlayerColor.values[i]);
    }
  }
}
