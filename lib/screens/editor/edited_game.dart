import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class EditedGame {
  List<GameState> _undoList = [];
  List<GameState> _redoList = [];
  GameState game;
  final ValueNotifier<GameState> gameStream;

  EditedGame({@required GameState game})
      : game = game,
        gameStream = ValueNotifier(game);

  void dispose() {
    gameStream.dispose();
  }

  void clearTile(int x, int y) {
    if (game.board.tiles[x][y] != const Empty()) {
      _saveState();

      game.board.tiles[x][y] = const Empty();
      _updateGame();
    }
  }

  void toggleTile(int x, int y, Tile tile) {
    if (game.board.tiles[x][y] is Empty) {
      _saveState();

      game.board.tiles[x][y] = tile;
      _updateGame();
    } else if (game.board.tiles[x][y].runtimeType == tile.runtimeType) {
      _saveState();

      game.board.tiles[x][y] = Empty();
      _updateGame();
    }
  }

  bool toggleEntity(int x, int y, EntityType type, Direction direction) {
    if (game.board.tiles[x][y] is Empty || game.board.tiles[x][y] is Arrow) {
      Iterable<Entity> miceThere = game.mice.where(
          (Entity entity) => entity.position.x == x && entity.position.y == y);

      Iterable<Entity> catsThere = game.cats.where(
          (Entity entity) => entity.position.x == x && entity.position.y == y);

      if (miceThere.isEmpty && catsThere.isEmpty) {
        _saveState();

        if (type == EntityType.Cat) {
          game.cats.add(Entity.fromEntityType(
              type, BoardPosition.centered(x, y, direction)));
        } else {
          game.mice.add(Entity.fromEntityType(
              type, BoardPosition.centered(x, y, direction)));
        }

        _updateGame();
        return true;
      } else if (miceThere.isNotEmpty && type == EntityType.Mouse) {
        _saveState();
        game.mice.remove(miceThere.first);
        _updateGame();
      } else if (catsThere.isNotEmpty is Cat && type == EntityType.Cat) {
        _saveState();
        game.cats.remove(catsThere.first);
        _updateGame();
      }
    }

    return false;
  }

  void clearEntity(int x, int y) {
    Iterable<Entity> miceThere = game.mice.where(
        (Entity entity) => entity.position.x == x && entity.position.y == y);

    Iterable<Entity> catsThere = game.cats.where(
        (Entity entity) => entity.position.x == x && entity.position.y == y);

    if (miceThere.isNotEmpty) {
      _saveState();

      game.mice.remove(miceThere.first);
      _updateGame();
    }

    if (catsThere.isNotEmpty) {
      _saveState();

      game.cats.remove(catsThere.first);
      _updateGame();
    }
  }

  void toggleWall(int x, int y, Direction direction) {
    _saveState();

    game.board.setWall(x, y, direction, !game.board.hasWall(direction, x, y));
    _updateGame();
  }

  void undo() {
    if (_undoList.isNotEmpty) {
      _redoList.add(game);
      game = _undoList.removeLast();

      _updateGame();
    }
  }

  void redo() {
    if (_redoList.isNotEmpty) {
      _undoList.add(game);
      game = _redoList.removeLast();

      _updateGame();
    }
  }

  void _updateGame() {
    gameStream.value = game;
  }

  void _saveState() {
    _undoList.add(game.copy());
    _redoList.clear();
  }
}
