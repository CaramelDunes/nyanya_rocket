import 'dart:async';

import 'package:meta/meta.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/screens/challenge/challenge_game_controller.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class LunchTimeGameController extends ChallengeGameController {
  int _score = 0;
  int _targetScore = 0;

  StreamController<int> _scoreStream = StreamController();

  LunchTimeGameController(
      {@required void Function() onWin, @required ChallengeData challenge})
      : super(onWin: onWin, challenge: challenge) {
    for (Entity e in game.entities) {
      if (e is Mouse) {
        _targetScore++;
      }
    }
  }

  @override
  StreamController<int> get scoreStream => _scoreStream;

  @override
  int get targetScore => _targetScore;

  @override
  void close() {
    super.close();

    _scoreStream.close();
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
    _scoreStream.add(_score);

    if (_score >= _targetScore) {
      running = false;
      onWin();
    }
  }

  @override
  void onReset() {
    _score = 0;
    _scoreStream.add(_score);
  }
}
