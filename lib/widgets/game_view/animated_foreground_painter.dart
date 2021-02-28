import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'walls_painter.dart';
import 'static_foreground_painter.dart';

class AnimatedForegroundPainter extends CustomPainter {
  final ValueListenable<GameState> game;
  final ValueListenable<BoardPosition?>? mistake;

  final Animation entityAnimation;

  AnimatedForegroundPainter(
      {required this.game, required this.entityAnimation, this.mistake})
      : super(repaint: entityAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    double tileWidth = size.width / 12;
    double tileHeight = size.height / 9;

    canvas.save();
    canvas.scale(tileWidth, tileHeight);
    StaticForegroundPainter.paintUnit(
        canvas, game.value, entityAnimation.value);
    _paintUnitMistake(canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }

  void _paintUnitMistake(Canvas canvas) {
    if (mistake != null &&
        mistake!.value != null &&
        entityAnimation.value > 15) {
      canvas.drawCircle(
          WallsPainter.centerOfPosition(mistake!.value!),
          0.55,
          Paint()
            ..color = Colors.red
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.1);
    }
  }
}
