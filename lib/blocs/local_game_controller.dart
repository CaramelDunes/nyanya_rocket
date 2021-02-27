import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/puzzle/animation_ticker.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class LocalGameController extends AnimationTicker<GameState> {
  final ValueNotifier<GameState> gameStream;

  LocalGameController(GameState game, GameSimulator gameSimulator)
      : gameStream = ValueNotifier(game),
        super(game, gameSimulator) {
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

  @mustCallSuper
  void dispose() {
    gameStream.dispose();
  }
}
