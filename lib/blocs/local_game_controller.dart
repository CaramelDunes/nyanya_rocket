import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class LocalGameController extends GameTicker<GameState> {
  final ValueNotifier<GameState> gameStream;

  LocalGameController(super.game, super.gameSimulator)
      : gameStream = ValueNotifier(game) {
    updateGame();
  }

  @protected
  void updateGame() {
    gameStream.value = game;
  }

  @override
  @mustCallSuper
  void afterUpdate() {
    updateGame();
  }

  @override
  @mustCallSuper
  void dispose() {
    gameStream.dispose();

    super.dispose();
  }
}
