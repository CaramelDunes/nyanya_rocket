
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/checkerboard_painter.dart';
import 'package:nyanya_rocket/widgets/game_view/foreground_painter.dart';
import 'package:nyanya_rocket/widgets/game_view/tiles_drawer.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class GameView extends StatefulWidget {
  final ValueListenable<Game> game;
  final ValueListenable<BoardPosition> mistake;
  final double timestamp;

  GameView({@required this.game, this.timestamp = 0, this.mistake});

  @override
  _GameViewState createState() {
    return _GameViewState();
  }
}

class _GameViewState extends State<GameView>
    with SingleTickerProviderStateMixin {
  Animation<int> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = IntTween(begin: 0, end: 29).animate(controller);
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('GameView rebuild');

    return CustomPaint(
      painter: CheckerboardPainter(),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              ValueListenableBuilder<Game>(
                  valueListenable: widget.game,
                  builder: (context, value, child) {
                    return TilesDrawer(value.board, constraints);
                  })),
      foregroundPainter: ForegroundPainter(
          game: widget.game,
          timestamp: widget.timestamp,
          mistake: widget.mistake,
          entityAnimation: animation),
      willChange: true,
    );
  }
}
