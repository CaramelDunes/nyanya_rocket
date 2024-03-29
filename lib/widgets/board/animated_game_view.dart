import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'animated_foreground_painter.dart';
import 'board_background_painter.dart';

class AnimatedGameView extends StatefulWidget {
  final ValueListenable<GameState> game;
  final ValueListenable<BoardPosition?>? mistake;

  const AnimatedGameView({super.key, required this.game, this.mistake});

  @override
  State<AnimatedGameView> createState() => _AnimatedGameViewState();
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
    final brightness = Theme.of(context).brightness;

    return RepaintBoundary(
      child: CustomPaint(
          isComplex: true,
          willChange: true,
          painter: BoardBackgroundPainter(
              board: widget.game.value.board, brightness: brightness),
          foregroundPainter: AnimatedForegroundPainter(
            game: widget.game,
            mistake: widget.mistake,
            entityAnimation: _animation,
            brightness: brightness,
          )),
    );
  }
}
