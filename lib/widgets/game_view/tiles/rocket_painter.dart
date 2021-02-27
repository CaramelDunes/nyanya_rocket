import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../utils.dart';

class RocketPainter extends CustomPainter {
  const RocketPainter(this.color, this.departed);

  factory RocketPainter.fromPlayerColor(PlayerColor? color,
      [bool departed = false]) {
    return RocketPainter(color?.color ?? Colors.grey, departed);
  }

  final Color color;
  final bool departed;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width, size.height);
    drawUnit(canvas, color, departed);
    canvas.restore();
  }

  @override
  bool shouldRepaint(RocketPainter oldDelegate) {
    return color != oldDelegate.color;
  }

  static void drawUnit(Canvas canvas, Color color, bool departed) {
    final rect = Rect.fromLTRB(0, 0, 1, 1);
    final gradient = RadialGradient(
      radius: 0.3,
      colors: [color, color.withAlpha(128)],
    );

    canvas.drawCircle(
        rect.center, 0.45, Paint()..shader = gradient.createShader(rect));
    canvas.drawCircle(
        rect.center,
        0.45,
        Paint()
          ..style = departed ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeWidth = 0.05);
  }
}
