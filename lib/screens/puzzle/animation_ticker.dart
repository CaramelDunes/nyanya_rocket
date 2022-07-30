import 'package:meta/meta.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class AnimationTicker<T extends GameState> {
  T _game;
  final GameSimulator gameSimulator;

  bool isRunning = false;

  AnimationTicker(this._game, this.gameSimulator) {
    gameSimulator.onMouseEaten = onMouseEaten;
    gameSimulator.onEntityInPit = onEntityInPit;
    gameSimulator.onEntityInRocket = onEntityInRocket;
    gameSimulator.onArrowExpiry = onArrowExpiry;
  }

  T get game => _game;

  set gameState(T g) {
    _game = g;
  }

  @protected
  void beforeUpdate() {}

  @protected
  void afterUpdate() {}

  void update() {
    if (isRunning) {
      beforeUpdate();

      gameSimulator.update(_game);

      afterUpdate();
    }
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
