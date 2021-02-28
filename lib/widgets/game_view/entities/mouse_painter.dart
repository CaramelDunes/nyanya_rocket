import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/entities/entity_painter.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class MousePainter extends CustomPainter {
  const MousePainter(this.direction);

  final Direction direction;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width, size.height);
    paintUnit(canvas, direction);
    canvas.restore();
  }

  @override
  bool shouldRepaint(MousePainter oldDelegate) {
    return direction != oldDelegate.direction;
  }

  static void paintUnit(Canvas canvas, Direction direction) {
    EntityPainter.mouseAnimations![direction.index].paintUnit(canvas, 0);
  }
}
