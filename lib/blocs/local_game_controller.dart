import 'dart:async';

import 'package:meta/meta.dart';
import 'package:nyanya_rocket/widgets/game_view/synchronous_animation.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class LocalGameController {
  static const Duration tickPeriod = Duration(milliseconds: 16);

  final StreamController<Game> gameStream = StreamController();

  final SynchronousController _animationController = SynchronousController();

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

  SynchronousController get animationController => _animationController;
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

  void updateGame() {
    gameStream.add(_game);
  }

  void beforeTick() {}
  void afterTick() {}

  void _tick(Timer timer) {
    if (_pauseDuration > Duration.zero) {
      _pauseDuration -= tickPeriod;
      return;
    }

    if (running) {
      beforeTick();

      _animationController.addGlobalTime(0.016);

      _game.tickEntities();
      _game.tickTiles();
      _game.tickEntities();
      _game.tickTiles();

      if (faster) {
        _game.tickEntities();
        _game.tickTiles();
        _animationController.addGlobalTime(0.016);
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

  void onMouseEaten(Mouse mouse, Cat cat) {}

  void onEntityInPit(Entity entity, int x, int y) {}

  void onEntityInRocket(Entity entity, int x, int y) {}

  void onArrowExpiry(Arrow arrow, int x, int y) {}
}
