import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../utils.dart';

class ArrowPainter extends CustomPainter {
  const ArrowPainter(this.color, this.direction, this.damaged);

  factory ArrowPainter.fromPlayerColor(PlayerColor? color, Direction direction,
      [bool damaged = false]) {
    return ArrowPainter(color?.color ?? Colors.grey, direction, damaged);
  }

  final Color color;
  final Direction direction;
  final bool damaged;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width, size.height);
    paintUnit(canvas, color, direction, false);
    canvas.restore();
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) {
    return color != oldDelegate.color;
  }

  static void paintUnit(
      Canvas canvas, Color color, Direction direction, bool damaged) {
    final bodyHeightRatio = 0.55;
    final bodyWidthRatio = 0.5;

    final arrow = arrowPath(bodyHeightRatio, bodyWidthRatio);

    final arrowHeightRatio = 0.75;
    final arrowWidthRatio = 0.65;
    final rect = Rect.fromLTRB(-0.5, -0.5, 0.5, 0.5);
    final roundedRect = RRect.fromRectAndRadius(rect, Radius.circular(0.15));

    canvas.save();
    canvas.translate(0.5, 0.5);
    if (damaged) canvas.scale(0.6);

    canvas.drawRRect(roundedRect, Paint()..color = color);
    canvas.drawRRect(
        roundedRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.02
          ..color = Colors.black);

    canvas.rotate((1 - direction.index) * pi / 2);

    canvas.scale(arrowWidthRatio, arrowHeightRatio);
    canvas.drawPath(arrow, Paint()..color = Colors.white);
    canvas.drawPath(
        arrow,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.05);

    canvas.restore();
  }

  static Path arrowPath(double bodyHeightRatio, double bodyWidthRatio) {
    Path p = Path();

    // Draw up arrow, starting from top point.
    p.moveTo(0, -0.5);
    p.lineTo(0.5, 0.5 - bodyHeightRatio);
    p.lineTo(bodyWidthRatio / 2, 0.5 - bodyHeightRatio);
    p.lineTo(bodyWidthRatio / 2, 0.5);
    p.lineTo(-bodyWidthRatio / 2, 0.5);
    p.lineTo(-bodyWidthRatio / 2, 0.5 - bodyHeightRatio);
    p.lineTo(-0.5, 0.5 - bodyHeightRatio);
    p.close();

    return p;
  }
}
