
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/checkerboard_painter.dart';
import 'package:nyanya_rocket/widgets/game_view/animated_foreground_painter.dart';
import 'package:nyanya_rocket/widgets/game_view/tiles_drawer.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class AnimatedGameView extends StatefulWidget {
  final ValueListenable<Game> game;
  final ValueListenable<BoardPosition> mistake;
  final double timestamp;

  AnimatedGameView({@required this.game, this.timestamp = 0, this.mistake});

  @override
  _AnimatedGameViewState createState() {
    return _AnimatedGameViewState();
  }
}

class _AnimatedGameViewState extends State<AnimatedGameView>
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
      foregroundPainter: AnimatedForegroundPainter(
          game: widget.game,
          timestamp: widget.timestamp,
          mistake: widget.mistake,
          entityAnimation: animation),
      willChange: true,
    );
  }
}
