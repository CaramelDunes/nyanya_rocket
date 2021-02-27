import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class WallsPainter {
  static final Paint wallPaint = Paint()..color = Colors.red;

  static Offset centerOfPosition(BoardPosition position) {
    double top = position.y + 1 / 2;

    switch (position.direction) {
      case Direction.Up:
        top -= (1 / BoardPosition.maxStep) * position.step;
        top += 1 / 2;
        break;

      case Direction.Down:
        top += (1 / BoardPosition.maxStep) * position.step;
        top -= 1 / 2;
        break;

      default:
        break;
    }

    double left = position.x + 1 / 2;

    switch (position.direction) {
      case Direction.Right:
        left += (1 / BoardPosition.maxStep) * position.step;
        left -= 1 / 2;
        break;

      case Direction.Left:
        left -= (1 / BoardPosition.maxStep) * position.step;
        left += 1 / 2;
        break;

      default:
        break;
    }

    return Offset(left, top);
  }

  static void paintUnitWalls(Canvas canvas, Board board) {
    const double wallWidth = 0.10;

    for (int x = 0; x < 12; x++) {
      for (int y = 0; y < 9; y++) {
        if (board.hasUpWall(x, y)) {
          canvas.drawRect(
              Rect.fromLTWH(x.toDouble(), y - wallWidth / 2, 1, wallWidth),
              wallPaint);
          canvas.drawCircle(
              Offset(x.toDouble(), y.toDouble()), wallWidth, wallPaint);
          canvas.drawCircle(Offset(x + 1, y.toDouble()), wallWidth, wallPaint);
        }

        if (board.hasLeftWall(x, y)) {
          canvas.drawRect(
              Rect.fromLTWH(x - wallWidth / 2, y.toDouble(), wallWidth, 1),
              wallPaint);
          canvas.drawCircle(
              Offset(x.toDouble(), y.toDouble()), wallWidth, wallPaint);
          canvas.drawCircle(Offset(x.toDouble(), y + 1), wallWidth, wallPaint);
        }

        if (y == 8) {
          if (board.hasDownWall(x, y)) {
            canvas.drawRect(
                Rect.fromLTWH(
                    x.toDouble(), y + 1 - wallWidth / 2, 1, wallWidth),
                wallPaint);
            canvas.drawCircle(
                Offset(x.toDouble(), y + 1), wallWidth, wallPaint);
            canvas.drawCircle(Offset(x + 1, y + 1), wallWidth, wallPaint);
          }
        }

        if (x == 11) {
          if (board.hasRightWall(x, y)) {
            canvas.drawRect(
                Rect.fromLTWH(
                    x + 1 - wallWidth / 2, y.toDouble(), wallWidth, 1),
                wallPaint);
            canvas.drawCircle(
                Offset(x + 1, y.toDouble()), wallWidth, wallPaint);
            canvas.drawCircle(Offset(x + 1, y + 1), wallWidth, wallPaint);
          }
        }
      }
    }
  }
}
