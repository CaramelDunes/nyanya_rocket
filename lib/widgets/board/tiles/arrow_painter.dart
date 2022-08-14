import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../utils.dart';

class ArrowPainter extends CustomPainter {
  static const bodyHeightRatio = 0.55;
  static const bodyWidthRatio = 0.5;
  static const arrowHeightRatio = 0.75;
  static const arrowWidthRatio = 0.65;
  static const strokeWidth = 0.02;

  const ArrowPainter(this.color, this.direction, this.scale, this.brightness);

  factory ArrowPainter.fromPlayerColor(PlayerColor? color, Direction direction,
      [double scale = 1.0, Brightness brightness = Brightness.light]) {
    return ArrowPainter(
        color?.color ?? Colors.grey, direction, scale, brightness);
  }

  final Color color;
  final Direction direction;
  final double scale;
  final Brightness brightness;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width, size.height);
    paintUnit(canvas, color, direction, false, scale, brightness);
    canvas.restore();
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) {
    return color != oldDelegate.color || brightness != oldDelegate.brightness;
  }

  static void paintUnit(
      Canvas canvas, Color color, Direction direction, bool damaged,
      [double scale = 1.0, Brightness brightness = Brightness.light]) {
    canvas.save();
    canvas.translate(0.5, 0.5);
    if (damaged) canvas.scale(0.6);
    canvas.scale(scale);
    canvas.rotate((1 - direction.index) * pi / 2);

    _actuallyPaintUnit(canvas, color, brightness);

    canvas.restore();
  }

  static void _actuallyPaintUnit(
      Canvas canvas, Color color, Brightness brightness) {
    final arrow = arrowPath(bodyHeightRatio, bodyWidthRatio);
    const rect = Rect.fromLTRB(-0.5 + strokeWidth / 2, -0.5 + strokeWidth / 2,
        0.5 - strokeWidth / 2, 0.5 - strokeWidth / 2);
    final roundedRect =
        RRect.fromRectAndRadius(rect, const Radius.circular(0.15));

    final primaryColor =
        brightness == Brightness.light ? Colors.white : Colors.black;
    final secondaryColor =
        brightness == Brightness.light ? Colors.black : Colors.white;

    canvas.drawRRect(roundedRect, Paint()..color = color);
    canvas.drawRRect(
        roundedRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..color = secondaryColor);

    canvas.scale(arrowWidthRatio, arrowHeightRatio);
    canvas.drawPath(arrow, Paint()..color = primaryColor);
    canvas.drawPath(
        arrow,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.05
          ..color = secondaryColor);
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
