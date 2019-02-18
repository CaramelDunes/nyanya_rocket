import 'package:meta/meta.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/screens/challenge/challenge_game_controller.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class OneHundredMiceGameController extends ChallengeGameController {
  OneHundredMiceGameController(
      {void Function() onWin, @required ChallengeData challenge})
      : super(onWin: onWin, challenge: challenge);

  @override
  void onEntityInRocket(Entity entity, int x, int y) {
    if (game.scoreOf(PlayerColor.Blue) >= 100) {
      departRockets();
      onWin();
    }
  }
}
