import 'package:meta/meta.dart';
import 'package:nyanya_rocket/blocs/local_game_controller.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class EditorGameController extends LocalGameController {
  EditorGameController({@required Game game}) : super(game) {
    running = false;
  }

  void toggleTile(int x, int y, Tile tile) {
    if (game.board.tiles[x][y] is Empty) {
      game.board.tiles[x][y] = tile;
      updateGame();
    } else if (game.board.tiles[x][y].runtimeType == tile.runtimeType) {
      game.board.tiles[x][y] = Empty();
      updateGame();
    }
  }

  bool toggleEntity(int x, int y, EntityType type, Direction direction) {
    if (!running) {
      if (game.board.tiles[x][y] is Empty || game.board.tiles[x][y] is Arrow) {
        Iterable<Entity> miceThere = game.mice.where((Entity entity) =>
            entity.position.x == x && entity.position.y == y);

        Iterable<Entity> catsThere = game.cats.where((Entity entity) =>
            entity.position.x == x && entity.position.y == y);

        if (miceThere.isEmpty && catsThere.isEmpty) {
          if (type == EntityType.Cat) {
            game.cats.add(Entity.fromEntityType(
                type, BoardPosition.centered(x, y, direction)));
          } else {
            game.mice.add(Entity.fromEntityType(
                type, BoardPosition.centered(x, y, direction)));
          }

          updateGame();
          return true;
        } else if (miceThere.isNotEmpty && type == EntityType.Mouse) {
          game.mice.remove(miceThere.first);
          updateGame();
        } else if (catsThere.isNotEmpty is Cat && type == EntityType.Cat) {
          game.cats.remove(catsThere.first);
          updateGame();
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
