import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'checkerboard_painter.dart';
import 'tiles/tile_painter.dart';

class BoardBackgroundPainterChanging extends CustomPainter {
  final bool darkModeEnabled;
  final ValueListenable<GameState> game;

  BoardBackgroundPainterChanging(
      {required this.game, required this.darkModeEnabled})
      : super();

  @override
  void paint(Canvas canvas, Size size) {
    final double tileWidth = size.width / 12;
    final double tileHeight = size.height / 9;

    canvas.save();
    canvas.scale(tileWidth, tileHeight);

    CheckerboardPainter.paintUnitCheckerboard(canvas, darkModeEnabled);
    TilePainter.paintUnitNonArrowTiles(game.value.board, canvas);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is! BoardBackgroundPainterChanging ||
        darkModeEnabled != oldDelegate.darkModeEnabled;
  }
}
