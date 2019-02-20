import 'package:meta/meta.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/screens/challenge/challenge_game_controller.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class LunchTimeGameController extends ChallengeGameController {
  int _score = 0;
  int _targetScore = 0;

  LunchTimeGameController(
      {@required void Function() onWin, @required ChallengeData challenge})
      : super(onWin: onWin, challenge: challenge) {
    for (Entity e in game.entities.values) {
      if (e is Mouse) {
        _targetScore++;
      }
    }
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

    if (_score >= _targetScore) {
      running = false;
      onWin();
    }
  }

  @override
  void onReset() {
    _score = 0;
  }
}
