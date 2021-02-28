import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/entities/entities_drawer_canvas.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class CatPainter extends CustomPainter {
  const CatPainter(this.direction);

  final Direction direction;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width, size.height);
    drawUnit(canvas, direction);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CatPainter oldDelegate) {
    return direction != oldDelegate.direction;
  }

  static void drawUnit(Canvas canvas, Direction direction) {
    EntitiesDrawerCanvas.catAnimations![direction.index].drawUnit(canvas, 0);
  }
}
