import 'package:meta/meta.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/screens/challenge/challenge_game_controller.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class RunAwayGameController extends ChallengeGameController {
  int _targetScore = 0;

  RunAwayGameController(
      {@required void Function() onWin, @required ChallengeData challenge})
      : super(onWin: onWin, challenge: challenge) {
    for (Entity e in game.entities.values) {
      if (e is! Cat) {
        _targetScore++;
      }
    }
  }

  @override
  void onMouseEaten(Mouse mouse, Cat cat) {
    pleaseReset();
  }

  @override
  void onEntityInPit(Entity entity, int x, int y) {
    if (entity is Mouse) {
      pleaseReset();
    }
  }

  @override
  void onEntityInRocket(Entity entity, int x, int y) {
    if (entity is Cat) {
      pleaseReset();
    } else {
      if (game.scoreOf(PlayerColor.Blue) >= _targetScore) {
        departRockets();
        onWin();
      }
    }
  }
}
