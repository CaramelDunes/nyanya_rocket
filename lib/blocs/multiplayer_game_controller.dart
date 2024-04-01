import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class MultiplayerGameController extends MultiplayerGameTicker {
  final ValueNotifier<GameState> gameStream;

  MultiplayerGameController(super.game) : gameStream = ValueNotifier(game);

  @protected
  void updateGame() {
    gameStream.value = game;
  }

  @override
  @mustCallSuper
  void afterUpdate() {
    super.afterUpdate();

    updateGame();
  }

  @mustCallSuper
  @override
  void dispose() {
    super.dispose();

    gameStream.dispose();
  }
}
