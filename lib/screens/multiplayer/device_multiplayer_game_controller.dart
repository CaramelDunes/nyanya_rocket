import 'dart:async';

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

  final List<StreamController<int>> scoreStreams =
      List.generate(4, (_) => StreamController(), growable: false);

  final StreamController<Duration> timeStream = StreamController();

  bool _canPlaceArrow = false;

  Duration _remainingTime = Duration(minutes: 3);
  final void Function(GameEvent event) onGameEvent;

  LocalMultiplayerGameController({
    @required this.board,
    this.onGameEvent,
  }) : super(GameState()..board = board.board()) {
    running = true;
    pauseFor(Duration(seconds: 3));
    timeStream.add(_remainingTime);
  }

  get canPlaceArrow => _canPlaceArrow;

  @override
  void close() {
    super.close();

    scoreStreams.forEach((StreamController stream) => stream.close());
    timeStream.close();
  }

  @override
  void afterTick() {
    _remainingTime -= Duration(milliseconds: 16);

    if (_remainingTime.inMilliseconds.abs() % Duration.millisecondsPerSecond <=
        16) {
      timeStream.add(_remainingTime);
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

    scoreStreams[rocket.player.index].add(game.scoreOf(rocket.player));
  }

  @override
  void setGameEvent(GameEvent event) {
    super.setGameEvent(event);

    if (event != GameEvent.None && onGameEvent != null) {
      onGameEvent(event);
    }
  }
}
