import 'dart:async';

import 'package:meta/meta.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class LocalGameController {
  static const Duration tickPeriod = Duration(milliseconds: 8);

  final StreamController<Game> gameStream = StreamController();

  Game _game;

  Timer _timer;

  bool running = false;
  bool faster = false;

  Duration _pauseDuration = Duration.zero;

  LocalGameController(this._game) {
    _timer = Timer.periodic(tickPeriod, _tick);
    updateGame();

    _game.onMouseEaten = onMouseEaten;
    _game.onEntityInPit = onEntityInPit;
    _game.onEntityInRocket = onEntityInRocket;
    _game.onArrowExpiry = onArrowExpiry;
  }

  Game get game => _game;

  void pauseFor(Duration duration) {
    _pauseDuration = duration;
  }

  bool get paused => _pauseDuration >= Duration.zero;

  set game(Game g) {
    _game = g;

    updateGame();

    _game.onMouseEaten = onMouseEaten;
    _game.onEntityInPit = onEntityInPit;
    _game.onEntityInRocket = onEntityInRocket;
    _game.onArrowExpiry = onArrowExpiry;
  }

  @protected
  void updateGame() {
    gameStream.add(_game);
  }

  @protected
  void beforeTick() {}

  @protected
  void afterTick() {}

  void _tick(Timer timer) {
    if (_pauseDuration > Duration.zero) {
      _pauseDuration -= tickPeriod;
      return;
    }

    if (running) {
      beforeTick();

      _game.tickEntities();
      _game.tickTiles();

      if (faster) {
        _game.tickEntities();
        _game.tickTiles();
      }

      updateGame();

      afterTick();
    }
  }

  void departRockets() {
    for (int x = 0; x < Board.width; x++) {
      for (int y = 0; y < Board.height; y++) {
        if (game.board.tiles[x][y] is Rocket) {
          game.board.tiles[x][y] = Rocket.departed(
              player: (game.board.tiles[x][y] as Rocket).player);
        }
      }
    }
  }

  @mustCallSuper
  void close() {
    _timer.cancel();
    gameStream.close();
  }

  @protected
  void onMouseEaten(Mouse mouse, Cat cat) {}

  @protected
  void onEntityInPit(Entity entity, int x, int y) {}

  @protected
  void onEntityInRocket(Entity entity, int x, int y) {}

  @protected
  void onArrowExpiry(Arrow arrow, int x, int y) {}
}
