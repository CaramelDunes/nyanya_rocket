import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';
import 'package:provider/provider.dart';

import '../../screens/settings/dark_mode.dart';
import 'animated_foreground_painter.dart';
import 'board_background_painter.dart';

class AnimatedGameView extends StatefulWidget {
  final ValueListenable<GameState> game;
  final ValueListenable<BoardPosition?>? mistake;

  const AnimatedGameView({Key? key, required this.game, this.mistake})
      : super(key: key);

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
    return RepaintBoundary(
      child: CustomPaint(
          isComplex: true,
          willChange: true,
          painter: BoardBackgroundPainter(
              board: widget.game.value.board,
              darkModeEnabled:
                  Provider.of<DarkMode>(context, listen: false).enabled),
          foregroundPainter: AnimatedForegroundPainter(
              game: widget.game,
              mistake: widget.mistake,
              entityAnimation: _animation)),
    );
  }
}
