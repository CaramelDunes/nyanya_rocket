import 'package:flutter/material.dart';

class CheckerboardPainter extends CustomPainter {
  static final List<Paint> lightPaints = [
    Paint()..color = Color(0xFFFBE0C2),
    Paint()..color = Color(0xFFC3B1F5)
  ];

  static final List<Paint> darkPaints = [
    Paint()..color = Colors.black26,
    Paint()..color = Colors.black45
  ];

  final List<Paint> paints;

  CheckerboardPainter({required bool useDarkColors})
      : paints = useDarkColors ? darkPaints : lightPaints;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 12, size.height / 9);

    paintUnitCheckerboard(canvas);

    canvas.restore();
  }

  static void paintUnitCheckerboard(Canvas canvas) {
    canvas.drawRect(Rect.fromLTRB(0, 0, 12, 9), lightPaints[0]);
    for (int x = 0; x < 12; x++) {
      for (int y = x.isEven ? 1 : 0; y < 9; y += 2) {
        canvas.drawRect(
            Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1), lightPaints[1]);
      }
    }
  }

  @override
  bool shouldRepaint(CheckerboardPainter oldDelegate) {
    return paints != oldDelegate.paints;
  }
}
