import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';
import 'package:provider/provider.dart';

import '../../screens/settings/dark_mode.dart';
import 'animated_foreground_painter.dart';
import 'board_background_painter_changing.dart';

class AnimatedGameViewChangingBackground extends StatefulWidget {
  final ValueListenable<GameState> game;

  const AnimatedGameViewChangingBackground({Key? key, required this.game})
      : super(key: key);

  @override
  _AnimatedGameViewChangingBackgroundState createState() =>
      _AnimatedGameViewChangingBackgroundState();
}

class _AnimatedGameViewChangingBackgroundState
    extends State<AnimatedGameViewChangingBackground>
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
          painter: BoardBackgroundPainterChanging(
              game: widget.game,
              darkModeEnabled:
                  Provider.of<DarkMode>(context, listen: false).enabled),
          foregroundPainter: AnimatedForegroundPainter(
              game: widget.game, entityAnimation: _animation)),
    );
  }
}
