import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../utils.dart';

class RocketPainter extends CustomPainter {
  static const unitRadius = 0.40;
  static const unitStrokeWidth = 0.05;

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
    paintUnit(canvas, color, departed);
    canvas.restore();
  }

  @override
  bool shouldRepaint(RocketPainter oldDelegate) {
    return color != oldDelegate.color;
  }

  static void paintUnit(Canvas canvas, Color color, bool departed) {
    const rect = Rect.fromLTRB(0, 0, 1, 1);

    canvas.drawCircle(rect.center, unitRadius, Paint()..color = color);
    canvas.drawCircle(
        rect.center,
        unitRadius,
        Paint()
          ..style = departed ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeWidth = unitStrokeWidth);
  }
}
