import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/checkerboard_painter.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'walls_painter.dart';
import 'entities/entity_painter.dart';
import 'tiles/tile_painter.dart';

class StaticForegroundPainter extends CustomPainter {
  final GameState game;

  StaticForegroundPainter({required this.game});

  @override
  void paint(Canvas canvas, Size size) {
    double tileWidth = size.width / 12;
    double tileHeight = size.height / 9;

    canvas.save();
    canvas.scale(tileWidth, tileHeight);
    paintUnit(canvas, game, 0);
    canvas.restore();
  }

  static void paintUnit(Canvas canvas, GameState game, int frameNumber) {
    CheckerboardPainter.paintUnitCheckerboard(canvas);
    TilePainter.paintUnitTiles(game.board, canvas);
    WallsPainter.paintUnitWalls(canvas, game.board);

    EntityPainter.paintUnitEntities(canvas, game.mice, frameNumber);
    EntityPainter.paintUnitEntities(canvas, game.cats, frameNumber);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
