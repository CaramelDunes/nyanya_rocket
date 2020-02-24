import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class LocalGameController extends GameTicker<GameState> {
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
  void afterTick() {
    updateGame();
  }

  @mustCallSuper
  @override
  void close() {
    super.close();

    gameStream.dispose();
  }
}
