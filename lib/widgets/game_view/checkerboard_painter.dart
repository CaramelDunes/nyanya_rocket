import 'package:flutter/material.dart';

class CheckerboardPainter extends CustomPainter {
  static final List<Paint> lightPaints = [
    Paint()..color = Color(0xFFFBE0C2),
    Paint()..color = Color(0xFFC3B1F5)
  ];

  static final List<Paint> darkPaints = [
    Paint()..color = Colors.black45,
    Paint()..color = Colors.black
  ];

  final List<Paint> paints;

  CheckerboardPainter({required bool useDarkColors})
      : paints = useDarkColors ? darkPaints : lightPaints;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, paints[0]);

    canvas.save();
    canvas.scale(size.width, size.height);

    for (int x = 0; x < 12; x++) {
      for (int y = x.isEven ? 1 : 0; y < 9; y += 2) {
        canvas.drawRect(Rect.fromLTWH(x / 12, y / 9, 1 / 12, 1 / 9), paints[1]);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CheckerboardPainter oldDelegate) {
    return paints != oldDelegate.paints;
  }
}
