import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../utils.dart';

class ArrowPainter extends CustomPainter {
  const ArrowPainter(this.color);

  factory ArrowPainter.fromPlayerColor(PlayerColor? color) {
    return ArrowPainter(color?.color ?? Colors.grey);
  }

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width, size.height);
    drawUnit(canvas, color, Direction.Up);
    canvas.restore();
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) {
    return color != oldDelegate.color;
  }

  static void drawUnit(Canvas canvas, Color color, Direction direction) {
    final bodyHeightRatio = 0.6;
    final bodyWidthRatio = 0.5;

    final arrow = arrowPath(bodyHeightRatio, bodyWidthRatio);

    final arrowHeightRatio = 0.75;
    final arrowWidthRatio = 0.65;
    final rect = Rect.fromLTRB(0, 0, 1, 1);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(0.15));

    canvas.save();

    switch (direction) {
      case Direction.Right:
        canvas.translate(1, 0);
        break;
      case Direction.Up:
        break;
      case Direction.Left:
        canvas.translate(0, 1);
        break;
      case Direction.Down:
        canvas.translate(1, 1);
        break;
    }

    canvas.rotate((1 - direction.index) * pi / 2);

    canvas.drawRRect(rrect, Paint()..color = color);
    canvas.drawRRect(
        rrect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.02
          ..color = Colors.black);

    canvas.translate((1 - arrowWidthRatio) / 2, (1 - arrowHeightRatio) / 2);
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
    p.moveTo(0.5, 0);
    p.lineTo(1, 1 - bodyHeightRatio);
    p.lineTo(0.5 + bodyWidthRatio / 2, 1 - bodyHeightRatio);
    p.lineTo(0.5 + bodyWidthRatio / 2, 1);
    p.lineTo(0.5 - bodyWidthRatio / 2, 1);
    p.lineTo(0.5 - bodyWidthRatio / 2, 1 - bodyHeightRatio);
    p.lineTo(0, 1 - bodyHeightRatio);
    p.close();

    return p;
  }
}
