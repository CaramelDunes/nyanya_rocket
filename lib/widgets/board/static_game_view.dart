import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'board_background_painter.dart';
import 'static_foreground_painter.dart';

class StaticGameView extends StatelessWidget {
  final GameState game;

  const StaticGameView({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return CustomPaint(
      willChange: false,
      isComplex: true,
      size: Size.infinite,
      painter:
          BoardBackgroundPainter(board: game.board, brightness: brightness),
      foregroundPainter:
          StaticForegroundPainter(game: game, brightness: brightness),
    );
  }
}
