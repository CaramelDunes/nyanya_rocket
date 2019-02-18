import 'package:meta/meta.dart';
import 'package:nyanya_rocket/blocs/local_game_controller.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class EditorGameController extends LocalGameController {
  EditorGameController({@required Game game}) : super(game) {
    running = false;
  }

  void placeTile(int x, int y, Tile tile) {
    if (game.board.tiles[x][y] is Empty) {
      game.board.tiles[x][y] = tile;
      updateGame();
    }
  }

  void clearTile(int x, int y) {
    if (!running) {
      game.board.tiles[x][y] = Empty();

      game.entities.removeWhere(
          (int, Entity e) => e.position.x == x && e.position.y == y);

      updateGame();
    }
  }

  bool placeEntity(int x, int y, EntityType type, Direction direction) {
    if (!running) {
      if (game.board.tiles[x][y] is Empty || game.board.tiles[x][y] is Arrow) {
        if (game.entities.entries
            .where((MapEntry entry) =>
                entry.value.position.x == x && entry.value.position.y == y)
            .isEmpty) {
          game.entities[(game.entities.lastKey() ?? 0) + 1] =
              Entity.fromEntityType(
                  type, BoardPosition.centered(x, y, direction));

          updateGame();
          return true;
        }
      }
    }

    return false;
  }

  bool toggleWall(int x, int y, Direction direction) {
    if (!running) {
      game.board.setWall(x, y, direction, !game.board.hasWall(direction, x, y));
      updateGame();
    }

    return false;
  }
}
