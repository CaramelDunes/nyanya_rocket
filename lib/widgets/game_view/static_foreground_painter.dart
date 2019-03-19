import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/entities_drawer_canvas.dart';
import 'package:nyanya_rocket/widgets/game_view/foreground_painter.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class StaticForegroundPainter extends CustomPainter {
  final Game game;
  final EntitiesDrawerCanvas _entitiesDrawer = EntitiesDrawerCanvas();

  StaticForegroundPainter({@required this.game});

  @override
  void paint(Canvas canvas, Size size) {
    ForegroundPainter.paintWalls(canvas, size, game.board);
    _entitiesDrawer.drawEntities(canvas, size, game.entities, 0);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
