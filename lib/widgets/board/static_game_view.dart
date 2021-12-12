import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';
import 'package:provider/provider.dart';

import '../../screens/settings/dark_mode.dart';
import 'board_background_painter.dart';
import 'static_foreground_painter.dart';

class StaticGameView extends StatelessWidget {
  final GameState game;

  const StaticGameView({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkMode>(
        builder: (BuildContext context, DarkMode darkMode, _) {
      return CustomPaint(
        willChange: false,
        isComplex: true,
        size: Size.infinite,
        painter: BoardBackgroundPainter(
            board: game.board, darkModeEnabled: darkMode.enabled),
        foregroundPainter: StaticForegroundPainter(game: game),
      );
    });
  }
}
