import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'mouse_painter.dart';
import 'cat_painter.dart';

class EntitiesDrawer {
  static Widget entityView(EntityType entityType, Direction direction) {
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
}
