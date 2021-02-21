import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/entities_drawer_canvas.dart';
import 'package:nyanya_rocket/widgets/game_view/foreground_painter.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class AnimatedForegroundPainter extends CustomPainter {
  final ValueListenable<GameState> game;
  final ValueListenable<BoardPosition?>? mistake;

  final Animation entityAnimation;

  AnimatedForegroundPainter(
      {required this.game, required this.entityAnimation, this.mistake})
      : super(repaint: entityAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    ForegroundPainter.paintWalls(canvas, size, game.value.board);

    EntitiesDrawerCanvas.drawEntities(
        canvas, size, game.value.cats, entityAnimation.value);
    EntitiesDrawerCanvas.drawEntities(
        canvas, size, game.value.mice, entityAnimation.value);

    _paintMistake(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void _paintMistake(Canvas canvas, Size size) {
    if (mistake != null &&
        mistake!.value != null &&
        entityAnimation.value > 15) {
      canvas.drawCircle(
          ForegroundPainter.centerOfPosition(mistake!.value!, size.width / 12),
          size.width / 24,
          Paint()
            ..color = Colors.red
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4);
    }
  }
}
