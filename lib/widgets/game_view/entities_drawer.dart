import 'dart:collection';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class EntitiesDrawer extends StatelessWidget {
  final SplayTreeMap<int, Entity> entities;
  final BoxConstraints constraints;
  final double tileSize;
  final FlareController animationController;

  static final List<String> directions = ['right', 'up', 'left', 'down'];

  EntitiesDrawer(this.entities, {this.constraints, this.animationController})
      : tileSize = constraints.maxWidth / 12;

  static Widget entityView(EntityType entityType, Direction direction,
      {FlareController animationController}) {
    switch (entityType) {
      case EntityType.Cat:
        return FlareActor(
          'assets/animations/cat_${directions[direction.index]}.flr',
          isPaused: animationController == null,
          controller: animationController,
        );
        break;

      case EntityType.Mouse:
        return FlareActor(
          'assets/animations/mouse_${directions[direction.index]}.flr',
          isPaused: animationController == null,
          controller: animationController,
        );
        break;

      default:
        return Container(
          color: Colors.transparent,
        );
    }
  }

  double topOfEntity(Entity entity) {
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

  double leftOfEntity(Entity entity) {
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

  Widget positionedEntityView(Entity entity) {
    final int catBonusSize = constraints.maxHeight ~/ 18;

    switch (entity.runtimeType) {
      case Cat:
        return Positioned(
            top: topOfEntity(entity) - catBonusSize,
            left: leftOfEntity(entity),
            width: tileSize,
            height: constraints.maxHeight / 9 + catBonusSize,
            child: entityView(EntityType.Cat, entity.position.direction,
                animationController: animationController));
        break;

      case Mouse:
        return Positioned(
            top: topOfEntity(entity),
            left: leftOfEntity(entity),
            width: constraints.maxWidth / 12,
            height: constraints.maxHeight / 9,
            child: entityView(EntityType.Mouse, entity.position.direction,
                animationController: animationController));
        break;

      default:
        return Container(
          color: Colors.transparent,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> overlay = List();
    entities.forEach((int key, Entity entity) {
      if (entity is! Cat) overlay.add(positionedEntityView(entity));
    });

    entities.forEach((int key, Entity entity) {
      if (entity is Cat) overlay.add(positionedEntityView(entity));
    }); //Draw cats after mice

    return Stack(children: overlay);
  }
}
