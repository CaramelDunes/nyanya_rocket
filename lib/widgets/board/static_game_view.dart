import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'board_background_painter.dart';
import 'static_foreground_painter.dart';

class StaticGameView extends StatelessWidget {
  final GameState game;

  const StaticGameView({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      willChange: false,
      isComplex: true,
      size: Size.infinite,
      painter: BoardBackgroundPainter(
          board: game.board, brightness: Theme.of(context).brightness),
      foregroundPainter: StaticForegroundPainter(game: game),
    );
  }
}
