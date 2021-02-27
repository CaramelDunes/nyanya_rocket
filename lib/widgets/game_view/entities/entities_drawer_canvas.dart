import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';
import 'canvas_rive_animation.dart';

class EntitiesDrawerCanvas {
  static List<CanvasRiveAnimation>? mouseAnimations;
  static List<CanvasRiveAnimation>? catAnimations;

  static double topOfEntity(Entity entity) {
    double top = entity.position.y.toDouble();

    switch (entity.position.direction) {
      case Direction.Up:
        top -= (1 / BoardPosition.maxStep) * entity.position.step;
        top += 1 / 2;
        break;

      case Direction.Down:
        top += (1 / BoardPosition.maxStep) * entity.position.step;
        top -= 1 / 2;
        break;

      default:
        break;
    }

    return top;
  }

  static double leftOfEntity(Entity entity) {
    double left = entity.position.x.toDouble();

    switch (entity.position.direction) {
      case Direction.Right:
        left += (1 / BoardPosition.maxStep) * entity.position.step;
        left -= 1 / 2;
        break;

      case Direction.Left:
        left -= (1 / BoardPosition.maxStep) * entity.position.step;
        left += 1 / 2;
        break;

      default:
        break;
    }

    return left;
  }

  static void drawUnit(Entity entity, Canvas canvas, int frameNb) {
    canvas.save();
    canvas.translate(leftOfEntity(entity), topOfEntity(entity));

    final double catBonusSize = 1 / 2;

    switch (entity.runtimeType) {
      case Cat:
        canvas.translate(0.1, -catBonusSize);
        canvas.scale(1 - 0.2, 1 + catBonusSize);
        catAnimations![entity.position.direction.index]
            .drawUnit(canvas, frameNb);
        break;

      case GoldenMouse:
        mouseAnimations![entity.position.direction.index].drawUnit(
            canvas,
            frameNb,
            Paint()
              ..colorFilter = ColorFilter.mode(
                  Colors.yellow.withOpacity(0.5), BlendMode.srcATop));
        break;

      case SpecialMouse:
        mouseAnimations![entity.position.direction.index].drawUnit(
            canvas,
            frameNb,
            Paint()
              ..colorFilter = ColorFilter.mode(
                  Colors.pink.withOpacity(0.5), BlendMode.srcATop));
        break;

      case Mouse:
        mouseAnimations![entity.position.direction.index]
            .drawUnit(canvas, frameNb);
        break;

      default:
        break;
    }

    canvas.restore();
  }

  static void drawUnitEntities(Canvas canvas, Iterable<Entity> entities,
      [int frameNb = 0]) {
    entities.forEach((Entity entity) {
      drawUnit(entity, canvas, frameNb);
    });
  }
}
