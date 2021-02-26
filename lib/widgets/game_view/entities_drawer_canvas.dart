import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/canvas_rive_animation.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class EntitiesDrawerCanvas {
  static List<CanvasRiveAnimation>? mouseAnimations;
  static List<CanvasRiveAnimation>? catAnimations;

  static double topOfEntity(Entity entity, double tileSize) {
    double top = entity.position.y * tileSize;

    switch (entity.position.direction) {
      case Direction.Up:
        top -= (tileSize / BoardPosition.maxStep) * entity.position.step;
        top += tileSize / 2;
        break;

      case Direction.Down:
        top += (tileSize / BoardPosition.maxStep) * entity.position.step;
        top -= tileSize / 2;
        break;

      default:
        break;
    }

    return top;
  }

  static double leftOfEntity(Entity entity, double tileSize) {
    double left = entity.position.x * tileSize;

    switch (entity.position.direction) {
      case Direction.Right:
        left += (tileSize / BoardPosition.maxStep) * entity.position.step;
        left -= tileSize / 2;
        break;

      case Direction.Left:
        left -= (tileSize / BoardPosition.maxStep) * entity.position.step;
        left += tileSize / 2;
        break;

      default:
        break;
    }

    return left;
  }

  static void draw(Entity entity, double tileSize, Canvas canvas, int frameNb) {
    final double catBonusSize = tileSize / 2;

    switch (entity.runtimeType) {
      case Cat:
        catAnimations![entity.position.direction.index].draw(
            canvas,
            Size(tileSize, tileSize + catBonusSize),
            leftOfEntity(entity, tileSize),
            topOfEntity(entity, tileSize) - catBonusSize,
            frameNb);
        break;

      case GoldenMouse:
        mouseAnimations![entity.position.direction.index].draw(
            canvas,
            Size(tileSize, tileSize),
            leftOfEntity(entity, tileSize),
            topOfEntity(entity, tileSize),
            frameNb,
            Paint()
              ..colorFilter = ColorFilter.mode(
                  Colors.yellow.withOpacity(0.5), BlendMode.srcATop));
        break;

      case SpecialMouse:
        mouseAnimations![entity.position.direction.index].draw(
            canvas,
            Size(tileSize, tileSize),
            leftOfEntity(entity, tileSize),
            topOfEntity(entity, tileSize),
            frameNb,
            Paint()
              ..colorFilter = ColorFilter.mode(
                  Colors.pink.withOpacity(0.5), BlendMode.srcATop));
        break;

      case Mouse:
        mouseAnimations![entity.position.direction.index].draw(
            canvas,
            Size(tileSize, tileSize),
            leftOfEntity(entity, tileSize),
            topOfEntity(entity, tileSize),
            frameNb);
        break;

      default:
        break;
    }
  }

  static void drawEntities(Canvas canvas, Size size, Iterable<Entity> entities,
      [int frameNb = 0]) {
    double tileSize = size.width / 12;
    entities.forEach((Entity entity) {
      draw(entity, tileSize, canvas, frameNb);
    });
  }
}
