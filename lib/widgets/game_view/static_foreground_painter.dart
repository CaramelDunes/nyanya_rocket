import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/entities_drawer_canvas.dart';
import 'package:nyanya_rocket/widgets/game_view/foreground_painter.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class StaticForegroundPainter extends CustomPainter {
  final GameState game;

  StaticForegroundPainter({required this.game});

  @override
  void paint(Canvas canvas, Size size) {
    ForegroundPainter.paintWalls(canvas, size, game.board);
    // EntitiesDrawerCanvas.drawEntities(canvas, size, game.cats, 0);
    // EntitiesDrawerCanvas.drawEntities(canvas, size, game.mice, 0);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
