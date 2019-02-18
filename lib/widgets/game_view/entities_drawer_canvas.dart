import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/cat_drawer.dart';
import 'package:nyanya_rocket/widgets/game_view/mouse_drawer.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

//TODO Performance improvements: Entities pixel version should be
// stored and blitted to the canvas instead of being computed for every entity

class EntitiesDrawerCanvas {
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

  static void draw(Entity entity, double tileSize, Canvas canvas) {
    final double catBonusSize = tileSize / 2;

    switch (entity.runtimeType) {
      case Cat:
        CatDrawer.draw(
            canvas,
            Size(tileSize, tileSize + catBonusSize),
            leftOfEntity(entity, tileSize),
            topOfEntity(entity, tileSize) - catBonusSize,
            entity.position.direction);
        break;

      case GoldenMouse:
      case Mouse:
        MouseDrawer.draw(
            canvas,
            Size(tileSize, tileSize),
            leftOfEntity(entity, tileSize),
            topOfEntity(entity, tileSize),
            entity.position.direction,
            entity is GoldenMouse);
        break;

      default:
        break;
    }
  }

  static void drawEntities(
      Canvas canvas, Size size, SplayTreeMap<int, Entity> entities) {
    double tileSize = size.width / 12;

    entities.forEach((int key, Entity entity) {
      if (entity is! Cat) {
        draw(entity, tileSize, canvas);
      }
    });

    entities.forEach((int key, Entity entity) {
      if (entity is Cat) {
        draw(entity, tileSize, canvas);
      }
    });
  }
}
