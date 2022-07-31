import 'package:flutter/foundation.dart';

import 'package:nyanya_rocket/screens/challenge/challenge_game_controller.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class LunchTimeGameController extends ChallengeGameController {
  int _score = 0;
  int _targetScore = 0;

  final ValueNotifier<int> _scoreStream = ValueNotifier(0);

  LunchTimeGameController({required super.onWin, required super.challenge}) {
    _targetScore = game.mice.length;
  }

  @override
  ValueNotifier<int> get scoreStream => _scoreStream;

  @override
  int get targetScore => _targetScore;

  @override
  void dispose() {
    super.dispose();

    _scoreStream.dispose();
  }

  @override
  void onEntityInPit(Entity entity, int x, int y) {
    if (entity is Mouse) {
      mistakeMade(entity.position);
    }
  }

  @override
  void onMouseEaten(Mouse mouse, Cat cat) {
    _score++;
    _scoreStream.value = _score;

    if (_score >= _targetScore) {
      running = false;
      onWin();
    }
  }

  @override
  void onReset() {
    _score = 0;
    _scoreStream.value = 0;
  }
}
