import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class WallsPainter {
  static const unitStrokeWidth = 0.08;
  static final Paint wallPaint = Paint()
    ..color = Colors.red
    ..strokeWidth = unitStrokeWidth
    ..strokeCap = StrokeCap.round;

  static Offset centerOfPosition(BoardPosition position) {
    double top = position.y + 1 / 2;
    double left = position.x + 1 / 2;

    switch (position.direction) {
      case Direction.Up:
        top -= (1 / BoardPosition.maxStep) * position.step;
        top += 1 / 2;
        break;

      case Direction.Down:
        top += (1 / BoardPosition.maxStep) * position.step;
        top -= 1 / 2;
        break;

      case Direction.Right:
        left += (1 / BoardPosition.maxStep) * position.step;
        left -= 1 / 2;
        break;

      case Direction.Left:
        left -= (1 / BoardPosition.maxStep) * position.step;
        left += 1 / 2;
        break;
    }

    return Offset(left, top);
  }

  static void paintUnitWalls(Canvas canvas, Board board) {
    for (int x = 0; x < 12; x++) {
      for (int y = 0; y < 9; y++) {
        if (board.hasUpWall(x, y)) {
          canvas.drawLine(Offset(x.toDouble(), y.toDouble()),
              Offset(x + 1, y.toDouble()), wallPaint);
        }

        if (board.hasLeftWall(x, y)) {
          canvas.drawLine(Offset(x.toDouble(), y.toDouble()),
              Offset(x.toDouble(), y + 1), wallPaint);
        }

        if (y == 8) {
          if (board.hasDownWall(x, y)) {
            canvas.drawLine(
                Offset(x.toDouble(), y + 1), Offset(x + 1, y + 1), wallPaint);
          }
        }

        if (x == 11) {
          if (board.hasRightWall(x, y)) {
            canvas.drawLine(
                Offset(x + 1, y.toDouble()), Offset(x + 1, y + 1), wallPaint);
          }
        }
      }
    }
  }
}
