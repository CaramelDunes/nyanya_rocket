import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'walls_painter.dart';
import 'entities/entities_drawer_canvas.dart';
import 'tiles/tiles_drawer.dart';

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
    TilesDrawer.drawUnitTiles(game.board, canvas);
    WallsPainter.paintUnitWalls(canvas, game.board);

    EntitiesDrawerCanvas.drawUnitEntities(canvas, game.cats, frameNumber);
    EntitiesDrawerCanvas.drawUnitEntities(canvas, game.mice, frameNumber);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
