import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:nyanya_rocket/blocs/multiplayer_game_controller.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class ArrowPosition {
  final int x;
  final int y;

  ArrowPosition(this.x, this.y);
}

class LocalMultiplayerGameController extends MultiplayerGameController {
  final MultiplayerBoard board;

  final List<ValueNotifier<int>> scoreStreams =
      List.generate(4, (_) => ValueNotifier(0), growable: false);

  final ValueNotifier<Duration> timeStream = ValueNotifier(Duration.zero);

  bool _canPlaceArrow = false;

  Duration _remainingTime = Duration(minutes: 3);
  final void Function(GameEvent event) onGameEvent;

  LocalMultiplayerGameController({
    @required this.board,
    this.onGameEvent,
  }) : super(MultiplayerGameState()..board = board.board()) {
    running = true;
//    pauseFor(Duration(seconds: 3));
    timeStream.value = _remainingTime;
  }

  get canPlaceArrow => _canPlaceArrow;

  @override
  void close() {
    scoreStreams
        .forEach((ValueNotifier valueNotifier) => valueNotifier.dispose());
    timeStream.dispose();

    super.close();
  }

  @override
  void afterTick() {
    _remainingTime -= Duration(milliseconds: 16);

    if (_remainingTime.inMilliseconds.abs() % Duration.millisecondsPerSecond <=
        16) {
      timeStream.value = _remainingTime;
    }

    super.afterTick();
  }

  @override
  set running(bool value) {
    super.running = value;
    _canPlaceArrow = true;
  }

  @override
  void onEntityInRocket(Entity entity, int x, int y) {
    super.onEntityInRocket(entity, x, y);

    Rocket rocket = game.board.tiles[x][y] as Rocket;

    scoreStreams[rocket.player.index].value = game.scoreOf(rocket.player);
  }

  @override
  void installGameEvent(GameEvent event) {
    super.installGameEvent(event);

    for (int i = 0; i < scoreStreams.length; i++) {
      scoreStreams[i].value = game.scoreOf(PlayerColor.values[i]);
    }

    if (event != GameEvent.None && onGameEvent != null) {
      onGameEvent(event);
    }
  }
}
