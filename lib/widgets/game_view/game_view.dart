import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/checkerboard_painter.dart';
import 'package:nyanya_rocket/widgets/game_view/foreground_painter.dart';
import 'package:nyanya_rocket/widgets/game_view/tiles_drawer.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class GameView extends StatelessWidget {
  final Board board;
  final SplayTreeMap<int, Entity> entities;
  final BoardPosition mistake;

  GameView({@required this.board, @required this.entities, this.mistake});

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: CheckerboardPainter(),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) =>
                TilesDrawer(board, constraints)),
        foregroundPainter: ForegroundPainter(
            board: board, entities: entities, mistake: mistake),
        isComplex: true,
        willChange: true,
      );
}
