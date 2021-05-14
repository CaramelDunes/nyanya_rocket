import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'mouse_painter.dart';
import 'cat_painter.dart';
import 'unit_painter.dart';

class EntityPainter {
  static List<UnitPainter>? mouseAnimations;
  static List<UnitPainter>? catAnimations;

  static void paintUnit(Entity entity, Canvas canvas, int frameNumber) {
    canvas.save();
    canvas.translate(leftOfEntity(entity), topOfEntity(entity));

    final double catBonusSize = 1 / 2;

    switch (entity.runtimeType) {
      case Cat:
        canvas.translate(0.1, -catBonusSize);
        canvas.scale(1 - 0.2, 1 + catBonusSize);
        catAnimations![entity.position.direction.index]
            .paintUnit(canvas, frameNumber);
        break;

      case GoldenMouse:
        mouseAnimations![entity.position.direction.index].paintUnit(
            canvas,
            frameNumber,
            Paint()
              ..colorFilter = ColorFilter.mode(
                  Colors.yellow.withOpacity(0.5), BlendMode.srcATop));
        break;

      case SpecialMouse:
        mouseAnimations![entity.position.direction.index].paintUnit(
            canvas,
            frameNumber,
            Paint()
              ..colorFilter = ColorFilter.mode(
                  Colors.pink.withOpacity(0.5), BlendMode.srcATop));
        break;

      case Mouse:
        mouseAnimations![entity.position.direction.index]
            .paintUnit(canvas, frameNumber);
        break;

      default:
        break;
    }

    canvas.restore();
  }

  static void paintUnitEntities(Canvas canvas, List<Entity> entities,
      [int frameNumber = 0]) {
    entities.forEach((Entity entity) {
      paintUnit(entity, canvas, frameNumber);
    });
  }

  static Widget widget(EntityType entityType, Direction direction) {
    switch (entityType) {
      case EntityType.Cat:
        return AspectRatio(
          aspectRatio: 0.5,
          child: CustomPaint(
            size: Size.infinite,
            painter: CatPainter(direction),
          ),
        );

      case EntityType.Mouse:
        return AspectRatio(
          aspectRatio: 1.0,
          child: CustomPaint(
            size: Size.infinite,
            painter: MousePainter(direction),
          ),
        );

      default:
        return Container(
          color: Colors.transparent,
        );
    }
  }

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
}
