import 'dart:async';

import 'package:meta/meta.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/screens/challenge/challenge_game_controller.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class OneHundredMiceGameController extends ChallengeGameController {
  StreamController<int> _scoreStream = StreamController();

  OneHundredMiceGameController(
      {void Function() onWin, @required ChallengeData challenge})
      : super(onWin: onWin, challenge: challenge);

  @override
  StreamController<int> get scoreStream => _scoreStream;

  @override
  int get targetScore => 100;

  @override
  void close() {
    super.close();

    _scoreStream.close();
  }

  @override
  void onReset() {
    _scoreStream.add(game.scoreOf(PlayerColor.Blue));
  }

  @override
  void onEntityInRocket(Entity entity, int x, int y) {
    _scoreStream.add(game.scoreOf(PlayerColor.Blue));

    if (game.scoreOf(PlayerColor.Blue) >= 100) {
      departRockets();
      onWin();
    }
  }
}
