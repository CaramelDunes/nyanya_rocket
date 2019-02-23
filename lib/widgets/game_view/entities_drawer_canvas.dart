import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/cached_flare_animation.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class EntitiesDrawerCanvas {
  static const List<String> _directions = ['right', 'up', 'left', 'down'];
  static final List<CachedFlareAnimation> mouseAnimations =
      List.generate(4, (int i) {
    return CachedFlareAnimation(
        assetFilename: "assets/animations/mouse_${_directions[i]}.flr",
        animationName: "Move");
  });

  static final List<CachedFlareAnimation> catAnimations =
      List.generate(4, (int i) {
    return CachedFlareAnimation(
        assetFilename: "assets/animations/cat_${_directions[i]}.flr",
        animationName: "Move");
  });

  double topOfEntity(Entity entity, double tileSize) {
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

  double leftOfEntity(Entity entity, double tileSize) {
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

  void draw(Entity entity, double tileSize, Canvas canvas, int frameNb) {
    final double catBonusSize = tileSize / 2;

    switch (entity.runtimeType) {
      case Cat:
        catAnimations[entity.position.direction.index].draw(
            canvas,
            Size(tileSize, tileSize + catBonusSize),
            leftOfEntity(entity, tileSize),
            topOfEntity(entity, tileSize) - catBonusSize,
            frameNb);
        break;

      case GoldenMouse:
      case Mouse:
        mouseAnimations[entity.position.direction.index].draw(
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

  void drawEntities(
      Canvas canvas, Size size, SplayTreeMap<int, Entity> entities,
      [int frameNb = 0]) {
    mouseAnimations
        .forEach((CachedFlareAnimation animation) => animation.advance());
    catAnimations
        .forEach((CachedFlareAnimation animation) => animation.advance());

    double tileSize = size.width / 12;

    entities.forEach((int key, Entity entity) {
      if (entity is! Cat) {
        draw(entity, tileSize, canvas, frameNb);
      }
    });

    entities.forEach((int key, Entity entity) {
      if (entity is Cat) {
        draw(entity, tileSize, canvas, frameNb);
      }
    });
  }
}
