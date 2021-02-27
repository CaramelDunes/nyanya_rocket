import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'static_foreground_painter.dart';
import 'checkerboard_painter.dart';
import 'tiles/tiles_drawer.dart';

class StaticGameView extends StatelessWidget {
  final GameState game;

  const StaticGameView({required this.game});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CheckerboardPainter(
          useDarkColors: Theme.of(context).brightness == Brightness.dark),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              TilesDrawer(game.board, constraints)),
      foregroundPainter: StaticForegroundPainter(game: game),
      willChange: false,
    );
  }
}
