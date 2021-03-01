import 'package:flutter/material.dart';

class PitPainter extends CustomPainter {
  const PitPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width, size.height);
    paintUnit(canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(PitPainter oldDelegate) {
    return false;
  }

  static void paintUnit(Canvas canvas) {
    canvas.drawRect(Rect.fromLTRB(0, 0, 1, 1), Paint()..color = Colors.black);
  }
}
