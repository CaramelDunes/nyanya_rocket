import 'package:flutter/material.dart';

import 'package:nyanya_rocket/screens/challenge/challenge_game_controller.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class OneHundredMiceGameController extends ChallengeGameController {
  final ValueNotifier<int> _scoreStream = ValueNotifier(0);

  OneHundredMiceGameController(
      {required super.onWin, required super.challenge});

  @override
  ValueNotifier<int> get scoreStream => _scoreStream;

  @override
  int get targetScore => 100;

  @override
  void dispose() {
    super.dispose();

    _scoreStream.dispose();
  }

  @override
  void onReset() {
    _scoreStream.value = game.scoreOf(PlayerColor.Blue);
  }

  @override
  void onEntityInRocket(Entity entity, int x, int y) {
    _scoreStream.value = game.scoreOf(PlayerColor.Blue);

    if (game.scoreOf(PlayerColor.Blue) >= 100) {
      gameSimulator.departRockets(game);
      running = false;
      onWin();
    }
  }
}
