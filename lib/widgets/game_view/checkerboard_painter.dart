import 'package:flutter/material.dart';

class CheckerboardPainter extends CustomPainter {
  static const Color beigeColor = Color(0xFFF9D0A2);
  static const Color purpleColor = Color(0xFFAC93F1);

  CheckerboardPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _paintBoard(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void _paintBoard(Canvas canvas, Size size) {
    List<Paint> paints = [Paint(), Paint()];
    paints[0].color = beigeColor;
    paints[1].color = purpleColor;

    double xStep = size.width / 12;
    double yStep = size.height / 9;

    for (int x = 0; x < 12; x++) {
      for (int y = 0; y < 9; y++) {
        canvas.drawRect(Rect.fromLTWH(xStep * x, yStep * y, xStep, yStep),
            paints[(x ^ y) & 1]);
      }
    }
  }
}
