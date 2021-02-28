import 'package:flutter/material.dart';

import 'unit_painter.dart';

class SimplePainter implements UnitPainter {
  final Color color;

  SimplePainter(this.color);

  void paintUnit(Canvas canvas, int frameNumber, [Paint? paint]) {
    canvas.drawOval(Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
        Paint()..color = color.withOpacity(0.7));
  }
}
