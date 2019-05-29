import 'package:flutter/material.dart';

class CheckerboardPainter extends CustomPainter {
  static final List<Paint> paints = [
    Paint()..color = Color(0xFFFBE0C2),
    Paint()..color = Color(0xFFC3B1F5)
  ];

  const CheckerboardPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double xStep = size.width / 12;
    final double yStep = size.height / 9;

    for (int x = 0; x < 12; x++) {
      for (int y = 0; y < 9; y++) {
        canvas.drawRect(Rect.fromLTWH(x * xStep, y * yStep, xStep, yStep),
            paints[(x ^ y) & 1]);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
