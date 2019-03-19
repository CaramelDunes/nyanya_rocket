import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class ForegroundPainter {
  static final Paint wallPaint = Paint()..color = Colors.red;

  static Offset centerOfPosition(BoardPosition position, double tileSize) {
    double top = position.y * tileSize + tileSize / 2;

    switch (position.direction) {
      case Direction.Up:
        top -= (tileSize / BoardPosition.maxStep) * position.step;
        top += tileSize / 2;
        break;

      case Direction.Down:
        top += (tileSize / BoardPosition.maxStep) * position.step;
        top -= tileSize / 2;
        break;

      default:
        break;
    }

    double left = position.x * tileSize + tileSize / 2;

    switch (position.direction) {
      case Direction.Right:
        left += (tileSize / BoardPosition.maxStep) * position.step;
        left -= tileSize / 2;
        break;

      case Direction.Left:
        left -= (tileSize / BoardPosition.maxStep) * position.step;
        left += tileSize / 2;
        break;

      default:
        break;
    }

    return Offset(left, top);
  }

  static void paintWalls(Canvas canvas, Size size, Board board) {
    double xStep = size.width / 12;
    double yStep = size.height / 9;

    double wallWidth = yStep * 0.15;

    for (int x = 0; x < 12; x++) {
      for (int y = 0; y < 9; y++) {
        if (board.hasUpWall(x, y)) {
          canvas.drawRect(
              Rect.fromLTWH(
                  x * xStep, y * yStep - wallWidth / 2, xStep, wallWidth),
              wallPaint);
          canvas.drawCircle(Offset(x * xStep, y * yStep), 4, wallPaint);
          canvas.drawCircle(Offset(x * xStep + xStep, y * yStep), 4, wallPaint);
        }

        if (board.hasLeftWall(x, y)) {
          canvas.drawRect(
              Rect.fromLTWH(
                  x * xStep - wallWidth / 2, y * yStep, wallWidth, yStep),
              wallPaint);
          canvas.drawCircle(Offset(x * xStep, y * yStep), 4, wallPaint);
          canvas.drawCircle(Offset(x * xStep, y * yStep + yStep), 4, wallPaint);
        }

        if (y == 8) {
          if (board.hasDownWall(x, y)) {
            canvas.drawRect(
                Rect.fromLTWH(x * xStep, (y + 1) * yStep - wallWidth / 2, xStep,
                    wallWidth),
                wallPaint);
            canvas.drawCircle(Offset(x * xStep, (y + 1) * yStep), 4, wallPaint);
            canvas.drawCircle(
                Offset(x * xStep + xStep, (y + 1) * yStep), 4, wallPaint);
          }
        }

        if (x == 11) {
          if (board.hasRightWall(x, y)) {
            canvas.drawRect(
                Rect.fromLTWH((x + 1) * xStep - wallWidth / 2, y * yStep,
                    wallWidth, yStep),
                wallPaint);
            canvas.drawCircle(Offset((x + 1) * xStep, y * yStep), 4, wallPaint);
            canvas.drawCircle(
                Offset((x + 1) * xStep, y * yStep + yStep), 4, wallPaint);
          }
        }
      }
    }
  }
}
