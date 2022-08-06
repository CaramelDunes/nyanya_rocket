import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'walls_painter.dart';
import 'entities/entity_painter.dart';
import 'tiles/tile_painter.dart';

class StaticForegroundPainter extends CustomPainter {
  final GameState game;

  const StaticForegroundPainter({required this.game});

  @override
  void paint(Canvas canvas, Size size) {
    final tileWidth = size.width / (12 + WallsPainter.unitStrokeWidth);
    final tileHeight = size.height / (9 + WallsPainter.unitStrokeWidth);

    canvas.save();

    canvas.scale(tileWidth, tileHeight);
    canvas.translate(
        WallsPainter.unitStrokeWidth / 2, WallsPainter.unitStrokeWidth / 2);

    paintUnit(canvas, game);

    canvas.restore();
  }

  static void paintUnit(Canvas canvas, GameState game) {
    TilePainter.paintUnitArrowTiles(game.board, canvas);
    WallsPainter.paintUnitWalls(canvas, game.board);

    EntityPainter.paintUnitEntities(canvas, game.mice);
    EntityPainter.paintUnitEntities(canvas, game.cats);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
