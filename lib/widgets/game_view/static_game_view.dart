import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'static_foreground_painter.dart';

class StaticGameView extends StatelessWidget {
  final GameState game;

  const StaticGameView({required this.game});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: StaticForegroundPainter(game: game),
      willChange: false,
      isComplex: true,
    );
  }
}
