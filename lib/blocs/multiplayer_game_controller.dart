import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

// TODO Somehow merge with LocalGameController
class MultiplayerGameController extends MultiplayerGameTicker {
  final ValueNotifier<Game> gameStream;

  MultiplayerGameController(Game game)
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
    updateGame();
  }

  @mustCallSuper
  @override
  void close() {
    super.close();

    gameStream.dispose();
  }
}
