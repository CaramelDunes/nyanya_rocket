import 'dart:math';

import 'package:flutter/material.dart';

class SpawnerPainter extends CustomPainter {
  const SpawnerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width, size.height);
    paintUnit(canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(SpawnerPainter oldDelegate) {
    return false;
  }

  static void paintUnit(Canvas canvas) {
    const RadialGradient gradient = RadialGradient(
        radius: 0.5, colors: [Color(0xfff8d512), Color(0xff81324a)]);

    canvas.save();
    canvas.translate(0.5, 0.5);
    canvas.scale(0.85);
    canvas.drawPath(spawnerPath(), Paint()..color = Colors.grey);
    canvas.drawPath(
        spawnerPath(),
        Paint()
          ..strokeWidth = 0.05
          ..style = PaintingStyle.stroke);
    canvas.drawCircle(
        Offset.zero,
        0.35,
        Paint()
          ..shader = gradient.createShader(
              Rect.fromCenter(center: Offset.zero, width: 0.70, height: 0.70)));
    canvas.restore();
  }

  static Path spawnerPath() {
    final cos60 = cos(60);
    final sin60 = sin(60);

    Path p = Path();

    // Draw up arrow, starting from top point.
    p.moveTo(0, -0.5);
    p.lineTo(-cos60 / 2, sin60);
    p.lineTo(-cos60 / 2, -sin60);
    p.lineTo(0, 0.5);
    p.lineTo(cos60 / 2, -sin60);
    p.lineTo(cos60 / 2, sin60);
    p.close();

    return p;
  }
}
