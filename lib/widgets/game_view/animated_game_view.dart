import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/animated_foreground_painter.dart';
import 'package:nyanya_rocket/widgets/game_view/checkerboard_painter.dart';
import 'package:nyanya_rocket/widgets/game_view/tiles_drawer.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class AnimatedGameView extends StatefulWidget {
  final ValueListenable<GameState> game;
  final ValueListenable<BoardPosition?>? mistake;

  AnimatedGameView({required this.game, this.mistake});

  @override
  _AnimatedGameViewState createState() => _AnimatedGameViewState();
}

class _AnimatedGameViewState extends State<AnimatedGameView>
    with SingleTickerProviderStateMixin {
  late Animation<int> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 350), vsync: this);
    _animation = IntTween(begin: 0, end: 29).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CheckerboardPainter(
          useDarkColors: Theme.of(context).brightness == Brightness.dark),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              ValueListenableBuilder<GameState>(
                  valueListenable: widget.game,
                  builder: (context, value, child) {
                    return TilesDrawer(value.board, constraints);
                  })),
      foregroundPainter: AnimatedForegroundPainter(
          game: widget.game,
          mistake: widget.mistake,
          entityAnimation: _animation),
      willChange: true,
    );
  }
}
