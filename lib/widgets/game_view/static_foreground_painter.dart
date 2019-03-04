import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/entities_drawer_canvas.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class StaticForegroundPainter extends CustomPainter {
  final ValueListenable<Game> game;
  final EntitiesDrawerCanvas _entitiesDrawer = EntitiesDrawerCanvas();

  StaticForegroundPainter({@required this.game});

  @override
  void paint(Canvas canvas, Size size) {
    _paintWalls(canvas, size);
    _entitiesDrawer.drawEntities(canvas, size, game.value.entities, 0);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

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

  void _paintWalls(Canvas canvas, Size size) {
    double xStep = size.width / 12;
    double yStep = size.height / 9;

    Paint wallPaint = Paint();
    wallPaint.color = Colors.red;

    double wallWidth = yStep * 0.15;

    for (int x = 0; x < 12; x++) {
      for (int y = 0; y < 9; y++) {
        if (game.value.board.hasUpWall(x, y)) {
          canvas.drawRect(
              Rect.fromLTWH(
                  x * xStep, y * yStep - wallWidth / 2, xStep, wallWidth),
              wallPaint);
        }

        if (game.value.board.hasLeftWall(x, y)) {
          canvas.drawRect(
              Rect.fromLTWH(
                  x * xStep - wallWidth / 2, y * yStep, wallWidth, yStep),
              wallPaint);
        }

        if (y == 8) {
          if (game.value.board.hasDownWall(x, y)) {
            canvas.drawRect(
                Rect.fromLTWH(x * xStep, (y + 1) * yStep - wallWidth / 2, xStep,
                    wallWidth),
                wallPaint);
          }
        }

        if (x == 11) {
          if (game.value.board.hasRightWall(x, y)) {
            canvas.drawRect(
                Rect.fromLTWH((x + 1) * xStep - wallWidth / 2, y * yStep,
                    wallWidth, yStep),
                wallPaint);
          }
        }
      }
    }
  }
}
