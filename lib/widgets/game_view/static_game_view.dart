import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/checkerboard_painter.dart';
import 'package:nyanya_rocket/widgets/game_view/static_foreground_painter.dart';
import 'package:nyanya_rocket/widgets/game_view/tiles_drawer.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class StaticGameView extends StatelessWidget {
  final ValueListenable<Game> game;
  final ValueListenable<BoardPosition> mistake;
  final double timestamp;

  StaticGameView({@required this.game, this.timestamp = 0, this.mistake});

  @override
  Widget build(BuildContext context) {
    print('GameView rebuild');

    return CustomPaint(
      painter: CheckerboardPainter(),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              ValueListenableBuilder<Game>(
                  valueListenable: game,
                  builder: (context, value, child) {
                    return TilesDrawer(value.board, constraints);
                  })),
      foregroundPainter: StaticForegroundPainter(game: game),
      willChange: true,
    );
  }
}
