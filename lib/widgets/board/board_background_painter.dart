import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../utils.dart';
import 'checkerboard_painter.dart';
import 'tiles/tile_painter.dart';

class BoardBackgroundPainter extends CustomPainter {
  final bool darkModeEnabled;
  late final Picture cached;

  BoardBackgroundPainter({required Board board, required this.darkModeEnabled})
      : super() {
    cached = createPicture((canvas) {
      CheckerboardPainter.paintUnitCheckerboard(canvas, darkModeEnabled);
      TilePainter.paintUnitNonArrowTiles(board, canvas);
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double tileWidth = size.width / 12;
    final double tileHeight = size.height / 9;

    canvas.save();

    canvas.scale(tileWidth, tileHeight);
    canvas.drawPicture(cached);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is! BoardBackgroundPainter ||
        darkModeEnabled != oldDelegate.darkModeEnabled;
  }
}
