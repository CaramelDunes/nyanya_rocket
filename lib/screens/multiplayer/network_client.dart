import 'dart:io';

import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../utils.dart';

enum NetworkGameStatus { connectingToServer, waitingForPlayers, playing, ended }

class NetworkClient extends GameTicker<MultiplayerGameState> {
  late ClientSocket _socket;
  NetworkGameStatus _status = NetworkGameStatus.connectingToServer;

  final List<String> _playerNicknames = List.filled(4, '<empty>');
  final ValueNotifier<GameState> gameStream = ValueNotifier(GameState());
  final ValueNotifier<Duration> timeStream = ValueNotifier(Duration.zero);
  final List<ValueNotifier<int>> scoreStreams =
      List.generate(4, (_) => ValueNotifier(0), growable: false);
  final ValueNotifier<NetworkGameStatus> statusNotifier =
      ValueNotifier(NetworkGameStatus.connectingToServer);

  final void Function(GameEvent event, Duration animationDuration)? onGameEvent;
  final void Function(PlayerColor assignedColor)? onRegisterSuccess;

  PlayerColor? assignedColor;

  NetworkClient(
      {required InternetAddress serverAddress,
      required String nickname,
      int port = 43122,
      int? ticket,
      this.onGameEvent,
      this.onRegisterSuccess})
      : super(MultiplayerGameState(), MultiplayerGameSimulator()) {
    gameSimulator.onEntityInRocket = _handleEntityInRocket;

    print('Connecting to $serverAddress:$port using ticket $ticket');
    _socket = ClientSocket(
        serverAddress: serverAddress,
        serverPort: port,
        nickname: nickname,
        ticket: ticket ?? 0,
        onGameUpdate: _handleGame,
        onPlayerRegister: _handleRegisterSuccess,
        onPlayerNicknames: _handlePlayerNicknames);
  }

  NetworkGameStatus get status => _status;

  @override
  void dispose() {
    _socket.dispose();
    timeStream.dispose();
    for (ValueNotifier stream in scoreStreams) {
      stream.dispose();
    }

    super.dispose();
  }

  List<String> get players => _playerNicknames;

  bool placeArrow(int x, int y, Direction direction) {
    _socket.sendArrowRequest(x, y, direction);

    return true;
  }

  Duration computeAnimationDuration(
      GameEvent event, int tickCount, int pauseUntil) {
    switch (event) {
      case GameEvent.SlowDown:
        return GameTicker.updatePeriod * (pauseUntil - tickCount);

      case GameEvent.SpeedUp:
        return GameTicker.updatePeriod * ((pauseUntil - tickCount) / 4);

      case GameEvent.CatMania:
      case GameEvent.MouseMania:
        return GameTicker.updatePeriod * ((pauseUntil - tickCount) / 2);

      case GameEvent.PlaceAgain:
        return GameTicker.updatePeriod * ((pauseUntil - tickCount) / 2) -
            const Duration(seconds: 3);

      case GameEvent.CatAttack:
      case GameEvent.MouseMonopoly:
      case GameEvent.EverybodyMove:
        return GameTicker.updatePeriod * ((pauseUntil - tickCount) / 2) -
            const Duration(seconds: 2);

      case GameEvent.None:
        return Duration.zero;
    }
  }

  void _mixGameEvents(
      MultiplayerGameState newGame, MultiplayerGameState afterCatchup) {
    if (newGame.currentEvent != GameEvent.None &&
        newGame.eventEnd != afterCatchup.eventEnd) {
      onGameEvent?.call(
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
      _status = NetworkGameStatus.playing;
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
    timeStream.value = floorDurationToTenthOfASecond(
        GameTicker.updatePeriod * (game.tickCount / 2));
  }

  void _handleRegisterSuccess(PlayerColor assignedColor) {
    print('Register Success!');

    if (_status == NetworkGameStatus.connectingToServer) {
      _status = NetworkGameStatus.waitingForPlayers;
    }

    this.assignedColor = assignedColor;

    onRegisterSuccess?.call(assignedColor);
  }

  void _handlePlayerNicknames(List<String> nicknames) {
    if (nicknames.length != 4) {
      print('Got ${nicknames.length} nicknames!');
    }

    for (int i = 0; i < nicknames.length; i++) {
      _playerNicknames[i] = nicknames[i];
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
