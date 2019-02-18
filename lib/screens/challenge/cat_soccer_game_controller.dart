import 'package:meta/meta.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/screens/challenge/challenge_game_controller.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class CatSoccerGameController extends ChallengeGameController {
  int _score = 0;
  int _targetScore = 20;

  CatSoccerGameController(
      {@required void Function() onWin, @required ChallengeData challenge})
      : super(onWin: onWin, challenge: challenge);

  @override
  void onEntityInRocket(Entity entity, int x, int y) {
    if (entity is Cat) {
      _score++;

      if (_score >= _targetScore) {
        onWin();
      }
    }
  }
}
