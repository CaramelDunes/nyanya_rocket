import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../utils.dart';
import 'checkerboard_painter.dart';
import 'tiles/tile_painter.dart';
import 'walls_painter.dart';

class BoardBackgroundPainter extends CustomPainter {
  final Brightness brightness;
  late final Picture cached;

  BoardBackgroundPainter({required Board board, required this.brightness}) {
    cached = createPicture((canvas) {
      CheckerboardPainter.paintUnitCheckerboard(canvas, brightness);
      TilePainter.paintUnitNonArrowTiles(board, canvas, brightness);
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final tileWidth = size.width / (12 + WallsPainter.unitStrokeWidth);
    final tileHeight = size.height / (9 + WallsPainter.unitStrokeWidth);

    canvas.save();

    canvas.scale(tileWidth, tileHeight);
    canvas.translate(
        WallsPainter.unitStrokeWidth / 2, WallsPainter.unitStrokeWidth / 2);

    canvas.drawPicture(cached);

    canvas.restore();
  }

  @override
  bool shouldRepaint(BoardBackgroundPainter oldDelegate) {
    return brightness != oldDelegate.brightness;
  }
}
