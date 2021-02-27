import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/puzzle/animation_ticker.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'animated_foreground_painter.dart';
import 'checkerboard_painter.dart';

class AnimatedGameView extends StatefulWidget {
  final ValueListenable<GameState> game;
  final ValueListenable<BoardPosition?>? mistake;
  final AnimationTicker? animationTicker;

  AnimatedGameView({required this.game, this.mistake, this.animationTicker});

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
    if (widget.animationTicker != null) {
      _controller.addListener(() {
        widget.animationTicker!.update();
      });
    }
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
      foregroundPainter: AnimatedForegroundPainter(
          game: widget.game,
          mistake: widget.mistake,
          entityAnimation: _animation),
      willChange: true,
    );
  }
}
