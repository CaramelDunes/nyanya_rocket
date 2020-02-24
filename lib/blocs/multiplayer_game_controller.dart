import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class MultiplayerGameController extends MultiplayerGameTicker {
  final ValueNotifier<GameState> gameStream;

  MultiplayerGameController(MultiplayerGameState game)
      : gameStream = ValueNotifier(game),
        super(game) {
    updateGame();
  }

  @protected
  void updateGame() {
    gameStream.value = game;
  }

  @override
  @mustCallSuper
  void afterTick() {
    super.afterTick();

    updateGame();
  }

  @mustCallSuper
  @override
  void close() {
    super.close();

    gameStream.dispose();
  }
}
