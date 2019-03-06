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

  LocalMultiplayerGameController({@required this.board})
      : super(Game()..board = board.board()) {
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

  bool placeArrow(int x, int y, PlayerColor player, Direction direction) {
    if (running && game.board.tiles[x][y] is Empty) {
      int count = 0;
      ArrowPosition last;
      int lastExpiration = Arrow.defaultExpiration;

      for (int i = 0; i < Board.width; i++) {
        // TODO Get rid of that ugly thing
        for (int j = 0; j < Board.height; j++) {
          if (game.board.tiles[i][j] is Arrow) {
            Arrow arrow = game.board.tiles[i][j] as Arrow;
            if (player == arrow.player) {
              count++;

              if (arrow.expiration < lastExpiration) {
                last = ArrowPosition(i, j);
                lastExpiration = arrow.expiration;
              }
            }
          }
        }
      }

      if (count >= 3) {
        game.board.tiles[last.x][last.y] = Empty();
      }

      game.board.tiles[x][y] = Arrow(player: player, direction: direction);
      updateGame();

      return true;
    }

    return false;
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
}
