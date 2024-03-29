import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../blocs/local_game_controller.dart';
import '../../models/puzzle_data.dart';

class Position {
  final int x;
  final int y;

  Position(this.x, this.y);
}

class PuzzleGameState {
  final bool isRunning;
  final bool hasReset;
  final bool isSpedUp;

  PuzzleGameState(
      {required this.isRunning,
      required this.hasReset,
      required this.isSpedUp});

  PuzzleGameState.reset({required this.isSpedUp})
      : isRunning = false,
        hasReset = true;
}

class PuzzleGameController extends LocalGameController {
  final PuzzleData puzzle;

  final List<List<Position>> placedArrows = [[], [], [], []];

  final List<ValueNotifier<int>> remainingArrowsStreams = [
    ValueNotifier(0),
    ValueNotifier(0),
    ValueNotifier(0),
    ValueNotifier(0)
  ];

  final void Function()? onWin;

  bool _canPlaceArrow = true;

  int _miceCount = 0;
  int _miceInRocket = 0;

  bool _pleaseReset = false;

  final ValueNotifier<BoardPosition?> _mistake = ValueNotifier(null);
  final ValueNotifier<PuzzleGameState> _gameStateNotifier =
      ValueNotifier(PuzzleGameState.reset(isSpedUp: false));

  Iterable<Cat>? _preMistakeCats;
  Iterable<Mouse>? _preMistakeMice;

  PuzzleGameController({this.onWin, required this.puzzle})
      : super(puzzle.getGame().copy(), PuzzleGameSimulator()) {
    for (int direction = 0; direction < Direction.values.length; direction++) {
      remainingArrowsStreams[direction].value =
          remainingArrows(Direction.values[direction]);
    }

    _miceCount = game.mice.length;
  }

  ValueNotifier<BoardPosition?> get mistake => _mistake;

  ValueNotifier<PuzzleGameState> get state => _gameStateNotifier;

  bool get canPlaceArrow => _canPlaceArrow;

  bool get isSpedUp => gameSimulator.speed == GameSpeed.Fast;

  bool get hasMadeMistake => _mistake.value != null;

  void toggleSpeedUp() {
    gameSimulator.speed = gameSimulator.speed == GameSpeed.Normal
        ? GameSpeed.Fast
        : GameSpeed.Normal;

    _gameStateNotifier.value = PuzzleGameState(
        isSpedUp: isSpedUp, isRunning: running, hasReset: _canPlaceArrow);
  }

  int remainingArrows(Direction direction) =>
      puzzle.availableArrows[direction.index] -
      placedArrows[direction.index].length;

  bool placeArrow(int x, int y, Direction direction) {
    if (_canPlaceArrow &&
        puzzle.availableArrows[direction.index] >
            placedArrows[direction.index].length &&
        game.board.tiles[x][y] is Empty) {
      game.board.tiles[x][y] =
          Arrow.notExpiring(player: PlayerColor.Blue, direction: direction);
      placedArrows[direction.index].add(Position(x, y));
      updateGame();
      remainingArrowsStreams[direction.index].value =
          remainingArrows(direction);
      return true;
    }

    return false;
  }

  bool hasArrow(int x, int y) {
    return game.board.tiles[x][y] is Arrow;
  }

  bool removeArrow(int x, int y) {
    if (!_canPlaceArrow) return false;

    for (int direction = 0; direction < Direction.values.length; direction++) {
      int index = placedArrows[direction].indexWhere(
          (Position position) => position.x == x && position.y == y);

      if (index > -1) {
        placedArrows[direction].removeAt(index);
        game.board.tiles[x][y] = const Empty();
        updateGame();
        remainingArrowsStreams[direction].value =
            remainingArrows(Direction.values[direction]);
        return true; // Remove at most one arrow
      }
    }

    return false;
  }

  void removeAllArrows() {
    if (!_canPlaceArrow) return;

    for (int direction = 0; direction < Direction.values.length; direction++) {
      for (Position position in placedArrows[direction]) {
        game.board.tiles[position.x][position.y] = const Empty();
      }

      placedArrows[direction].clear();
      remainingArrowsStreams[direction].value =
          remainingArrows(Direction.values[direction]);
    }
  }

  void reset() {
    running = false;
    _mistake.value = null;

    gameState = puzzle.getGame().copy();

    for (int direction = 0; direction < Direction.values.length; direction++) {
      for (Position position in placedArrows[direction]) {
        game.board.tiles[position.x][position.y] = Arrow.notExpiring(
            player: PlayerColor.Blue, direction: Direction.values[direction]);
      }
    }

    updateGame();
    _canPlaceArrow = true;
    _miceInRocket = 0;

    _gameStateNotifier.value = PuzzleGameState(
        isSpedUp: gameSimulator.speed == GameSpeed.Fast,
        isRunning: running,
        hasReset: _canPlaceArrow);
  }

  @override
  set running(bool value) {
    if (_mistake.value != null) {
      return;
    }

    super.running = value;

    if (_canPlaceArrow) {
      _canPlaceArrow = false;

      List<Mouse> newMice = [];
      List<BoardPosition> pendingArrowDeletions = [];

      for (Mouse? e in game.mice) {
        if (e!.position.step == BoardPosition.centerStep) {
          // FIXME No comment...
          e = gameSimulator.applyTileEffect(e, pendingArrowDeletions, game);
        }

        if (e != null) {
          newMice.add(e);
        }
      }

      game.mice = newMice;

      List<Cat> newCats = [];

      for (Cat? e in game.cats) {
        if (e!.position.step == BoardPosition.centerStep) {
          e = gameSimulator.applyTileEffect(e, pendingArrowDeletions, game);
        }

        if (e != null) {
          newCats.add(e);
        }
      }

      game.cats = newCats;
    }

    _gameStateNotifier.value = PuzzleGameState(
        isSpedUp: isSpedUp, isRunning: running, hasReset: _canPlaceArrow);
  }

  @override
  void onMouseEaten(Mouse mouse, Cat cat) {
    running = false;
    _mistake.value = mouse.position;
    _preMistakeMice = game.mice;
    _preMistakeCats = game.cats;
  }

  @override
  void onEntityInPit(Entity entity, int x, int y) {
    if (entity is Mouse) {
      running = false;
      _mistake.value = entity.position;
      _preMistakeMice = game.mice;
      _preMistakeCats = game.cats;
    }
  }

  @override
  void onEntityInRocket(Entity entity, int x, int y) {
    if (entity is Cat) {
      running = false;
      _mistake.value = entity.position;
      _preMistakeMice = game.mice;
      _preMistakeCats = game.cats;
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

        onWin?.call();
      }
    }
  }

  @override
  void afterUpdate() {
    if (_mistake.value != null &&
        _preMistakeCats != null &&
        _preMistakeMice != null) {
      game.cats = _preMistakeCats!.toList();
      game.mice = _preMistakeMice!.toList();
    }

    if (_pleaseReset) {
      _pleaseReset = false;
      reset();
    }

    super.afterUpdate();
  }
}
