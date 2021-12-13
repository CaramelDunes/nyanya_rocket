import 'dart:ui';

import '../../utils.dart';

abstract class CheckerboardPainter {
  static final List<Paint> lightPaints = [
    Paint()..color = const Color(0xFFFBE0C2),
    Paint()..color = const Color(0xFFC3B1F5)
  ];

  static final List<Paint> darkPaints = [
    Paint()..color = const Color(0xFF64594D),
    Paint()..color = const Color(0xFF4E4662),
  ];

  static final Picture lightModeCheckerboard =
      createPicture((canvas) => _paintUnitCheckerboard(canvas, false));
  static final Picture darkModeCheckerboard =
      createPicture((canvas) => _paintUnitCheckerboard(canvas, true));

  static void paintUnitCheckerboard(Canvas canvas, bool darkModeEnabled) {
    canvas.drawPicture(
        darkModeEnabled ? darkModeCheckerboard : lightModeCheckerboard);
  }

  static void _paintUnitCheckerboard(Canvas canvas, bool darkModeEnabled) {
    final List<Paint> paints = darkModeEnabled ? darkPaints : lightPaints;

    canvas.drawRect(const Rect.fromLTRB(0, 0, 12, 9), paints[0]);
    for (int x = 0; x < 12; x++) {
      for (int y = x.isEven ? 1 : 0; y < 9; y += 2) {
        canvas.drawRect(
            Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1), paints[1]);
      }
    }
  }
}
