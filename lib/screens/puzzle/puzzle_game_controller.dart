import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:nyanya_rocket/blocs/local_game_controller.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class Position {
  final int x;
  final int y;

  Position(this.x, this.y);
}

class PuzzleGameController extends LocalGameController {
  final PuzzleData puzzle;

  final List<List<Position>> placedArrows = [List(), List(), List(), List()];

  final List<StreamController<int>> remainingArrowsStreams = [
    StreamController(),
    StreamController(),
    StreamController(),
    StreamController()
  ];

  final void Function() onWin;
  final void Function(int x, int y) onMistake;

  bool _canPlaceArrow = true;

  int _miceCount = 0;
  int _miceInRocket = 0;

  bool _pleaseReset = false;

  ValueNotifier<BoardPosition> _mistake = ValueNotifier(null);

  PuzzleGameController({this.onWin, this.onMistake, @required this.puzzle})
      : super(puzzle.getGame()) {
    for (int direction = 0; direction < Direction.values.length; direction++) {
      remainingArrowsStreams[direction]
          .add(remainingArrows(Direction.values[direction]));
    }

    for (Entity e in game.entities.values) {
      if (e is! Cat) {
        _miceCount++;
      }
    }
  }

  ValueNotifier<BoardPosition> get mistake => _mistake;

  get canPlaceArrow => _canPlaceArrow;

  int remainingArrows(Direction direction) =>
      puzzle.availableArrows[direction.index] -
      placedArrows[direction.index].length;

  bool placeArrow(int x, int y, Direction direction) {
    if (_canPlaceArrow &&
        puzzle.availableArrows[direction.index] >
            placedArrows[direction.index].length &&
        game.board.tiles[x][y] is Empty) {
      game.board.tiles[x][y] =
          Arrow.notExpirable(player: PlayerColor.Blue, direction: direction);
      placedArrows[direction.index].add(Position(x, y));
      updateGame();
      remainingArrowsStreams[direction.index].add(remainingArrows(direction));
      return true;
    }

    return false;
  }

  bool removeArrow(int x, int y) {
    if (!_canPlaceArrow) return false;

    for (int direction = 0; direction < Direction.values.length; direction++) {
      int index = placedArrows[direction].indexWhere(
          (Position position) => position.x == x && position.y == y);

      if (index > -1) {
        placedArrows[direction].removeAt(index);
        game.board.tiles[x][y] = Empty();
        updateGame();
        remainingArrowsStreams[direction]
            .add(remainingArrows(Direction.values[direction]));
        return true; // Remove at most one arrow
      }
    }

    return false;
  }

  void removeAllArrows() {
    if (!_canPlaceArrow) return;

    for (int direction = 0; direction < Direction.values.length; direction++) {
      for (Position position in placedArrows[direction]) {
        game.board.tiles[position.x][position.y] = Empty();
      }

      placedArrows[direction].clear();
      remainingArrowsStreams[direction]
          .add(remainingArrows(Direction.values[direction]));
    }
  }

  void reset() {
    running = false;
    _mistake.value = null;

    game = puzzle.getGame();

    for (int direction = 0; direction < Direction.values.length; direction++) {
      placedArrows[direction].forEach((Position position) {
        game.board.tiles[position.x][position.y] = Arrow.notExpirable(
            player: PlayerColor.Blue, direction: Direction.values[direction]);
      });
    }

    updateGame();
    _canPlaceArrow = true;
    _miceInRocket = 0;
  }

  @override
  set running(bool value) {
    super.running = value;
    _canPlaceArrow = false;
  }

  @override
  void onMouseEaten(Mouse mouse, Cat cat) {
    running = false;
    _mistake.value = mouse.position;
  }

  @override
  void onEntityInPit(Entity entity, int x, int y) {
    if (entity is Mouse) {
      running = false;
      _mistake.value = entity.position;
    }
  }

  @override
  void onEntityInRocket(Entity entity, int x, int y) {
    if (entity is Cat) {
      running = false;
      _mistake.value = entity.position;
    } else {
      _miceInRocket++;
      if (_miceCount == _miceInRocket) {
        for (int x = 0; x < Board.width; x++) {
          for (int y = 0; y < Board.height; y++) {
            if (game.board.tiles[x][y] is Rocket) {
              game.board.tiles[x][y] = Rocket.departed(
                  player: (game.board.tiles[x][y] as Rocket).player);
            }
          }
        }

        if (onWin != null) {
          onWin();
        }
      }
    }
  }

  @override
  void afterTick() {
    if (_pleaseReset) {
      _pleaseReset = false;
      reset();
    }

    super.afterTick();
  }
}
