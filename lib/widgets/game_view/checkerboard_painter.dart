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

  CheckerboardPainter({@required bool useDarkColors})
      : paints = useDarkColors ? darkPaints : lightPaints;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, paints[0]);

    final double xStep = size.width / 12;
    final double yStep = size.height / 9;

    for (int x = 0; x < 12; x++) {
      for (int y = x.isEven ? 1 : 0; y < 9; y += 2) {
        canvas.drawRect(Rect.fromLTWH(x * xStep, y * yStep, xStep, yStep),
            paints[1]);
      }
    }
  }

  @override
  bool shouldRepaint(CheckerboardPainter oldDelegate) {
    return paints != oldDelegate.paints;
  }
}
