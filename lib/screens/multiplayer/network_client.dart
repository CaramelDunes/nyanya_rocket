import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

enum NetworkGameStatus { ConnectingToServer, WaitingForPlayers, Playing, Ended }

class NetworkClient extends GameTicker<MultiplayerGameState> {
  ClientSocket _socket;
  NetworkGameStatus _status = NetworkGameStatus.ConnectingToServer;

  final List<String> _players = List.filled(4, '');
  final ValueNotifier<GameState> gameStream = ValueNotifier(GameState());
  final ValueNotifier<Duration> timeStream = ValueNotifier(Duration.zero);
  final List<ValueNotifier<int>> scoreStreams =
      List.generate(4, (_) => ValueNotifier(0), growable: false);
  final ValueNotifier<NetworkGameStatus> statusNotifier =
      ValueNotifier(NetworkGameStatus.ConnectingToServer);

  final void Function(GameEvent event, Duration animationDuration) onGameEvent;
  final void Function(PlayerColor assignedColor) onRegisterSuccess;

  PlayerColor assignedColor;

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

  void dispose() {
    _socket?.dispose();
    timeStream.dispose();
    scoreStreams.forEach((ValueNotifier stream) => stream.dispose());

    super.dispose();
  }

  List<String> get players => _players;

  bool placeArrow(int x, int y, PlayerColor player, Direction direction) {
    if (_socket != null) {
      _socket.sendArrowRequest(x, y, direction);
    }

    return true;
  }

  Duration computeAnimationDuration(
      GameEvent event, int tickCount, int pauseUntil) {
    switch (event) {
      case GameEvent.SlowDown:
        return GameTicker.updatePeriod * (pauseUntil - tickCount);
        break;

      case GameEvent.SpeedUp:
        return GameTicker.updatePeriod * ((pauseUntil - tickCount) / 4);
        break;

      case GameEvent.CatMania:
      case GameEvent.MouseMania:
        return GameTicker.updatePeriod * ((pauseUntil - tickCount) / 2);
        break;

      case GameEvent.PlaceAgain:
        return GameTicker.updatePeriod * ((pauseUntil - tickCount) / 2) -
            Duration(seconds: 3);
        break;

      case GameEvent.CatAttack:
      case GameEvent.MouseMonopoly:
      case GameEvent.EverybodyMove:
        return GameTicker.updatePeriod * ((pauseUntil - tickCount) / 2) -
            Duration(seconds: 2);
        break;

      case GameEvent.None:
        return Duration.zero;
        break;
    }

    return Duration.zero;
  }

  void _mixGameEvents(
      MultiplayerGameState newGame, MultiplayerGameState afterCatchup) {
    if (onGameEvent != null &&
        newGame.currentEvent != GameEvent.None &&
        newGame.eventEnd != afterCatchup.eventEnd) {
      onGameEvent(
          newGame.currentEvent,
          computeAnimationDuration(
              newGame.currentEvent, newGame.tickCount, newGame.pauseUntil));
    }
  }

  void _handleGame(MultiplayerGameState receivedGame) {
    // Local simulation is late or on-time compared to server simulation, just
    // consume latest update.
    if (game.tickCount <= receivedGame.tickCount) {
      _mixGameEvents(receivedGame, game);

      if (game.tickCount == receivedGame.tickCount &&
          game.rng.state != receivedGame.rng.state) {
        print('On-time client RNG state discrepancy.');
      }

      if (game.tickCount < receivedGame.tickCount) {
        print('Skipping ${receivedGame.tickCount - game.tickCount} ticks.');
      }

      gameState = receivedGame;
    } else {
      // We are slightly early, align the server snapshot to our tick count.
      int earliness = game.tickCount - receivedGame.tickCount;

      print('Client is early by $earliness ticks.');

      // Only use our time frame if we are less than 60 ticks (~0.5 seconds)
      // in advance on the server.
      if (earliness <= 60) {
        (gameSimulator as MultiplayerGameSimulator)
            .fastForward(receivedGame, earliness);
      }

      _mixGameEvents(receivedGame, game);

      if (game.rng.state != receivedGame.rng.state) {
        print('Early client RNG state discrepancy');
      }

      gameState = receivedGame;
    }

    if (!running) {
      gameState = receivedGame;
      running = true;
      _status = NetworkGameStatus.Playing;
      statusNotifier.value = _status;
    }

    for (int i = 0; i < 4; i++) {
      scoreStreams[i].value = game.scoreOf(PlayerColor.values[i]);
    }
  }

  @override
  void afterUpdate() {
    super.afterUpdate();

    // Check if current event has ended.
    if (game.currentEvent != GameEvent.None &&
        game.eventEnd <= game.tickCount) {
      game.currentEvent = GameEvent.None;
    }

    gameStream.value = game;
    timeStream.value = GameTicker.updatePeriod * (game.tickCount / 2);
  }

  void _handleRegisterSuccess(PlayerColor assignedColor) {
    print('Register Success!');

    if (_status == NetworkGameStatus.ConnectingToServer) {
      _status = NetworkGameStatus.WaitingForPlayers;
    }

    this.assignedColor = assignedColor;

    if (onRegisterSuccess != null) {
      onRegisterSuccess(assignedColor);
    }
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
    if (entity is SpecialMouse) {
      // Pause for half a second waiting for server update.
      game.pauseUntil = game.tickCount + 60;
    }

    for (int i = 0; i < scoreStreams.length; i++) {
      scoreStreams[i].value = game.scoreOf(PlayerColor.values[i]);
    }
  }
}
