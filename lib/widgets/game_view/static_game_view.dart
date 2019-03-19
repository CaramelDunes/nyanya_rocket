import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/checkerboard_painter.dart';
import 'package:nyanya_rocket/widgets/game_view/static_foreground_painter.dart';
import 'package:nyanya_rocket/widgets/game_view/tiles_drawer.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class StaticGameView extends StatelessWidget {
  final Game game;

  const StaticGameView({@required this.game});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const CheckerboardPainter(),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              TilesDrawer(game.board, constraints)),
      foregroundPainter: StaticForegroundPainter(game: game),
      willChange: false,
    );
  }
}
