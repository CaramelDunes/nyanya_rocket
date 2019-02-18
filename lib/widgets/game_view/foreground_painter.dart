import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/entities_drawer_canvas.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class ForegroundPainter extends CustomPainter {
  final Board board;
  final SplayTreeMap<int, Entity> entities;

  ForegroundPainter(this.board, this.entities);

  @override
  void paint(Canvas canvas, Size size) {
    _paintWalls(canvas, size);
    EntitiesDrawerCanvas.drawEntities(canvas, size, entities);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void _paintWalls(Canvas canvas, Size size) {
    double xStep = size.width / 12;
    double yStep = size.height / 9;

    Paint wallPaint = Paint();
    wallPaint.color = Colors.red;

    double wallWidth = yStep * 0.15;

    for (int x = 0; x < 12; x++) {
      for (int y = 0; y < 9; y++) {
        if (board.hasUpWall(x, y)) {
          canvas.drawRect(
              Rect.fromLTWH(
                  x * xStep, y * yStep - wallWidth / 2, xStep, wallWidth),
              wallPaint);
        }

        if (board.hasLeftWall(x, y)) {
          canvas.drawRect(
              Rect.fromLTWH(
                  x * xStep - wallWidth / 2, y * yStep, wallWidth, yStep),
              wallPaint);
        }

        if (y == 8) {
          if (board.hasDownWall(x, y)) {
            canvas.drawRect(
                Rect.fromLTWH(x * xStep, (y + 1) * yStep - wallWidth / 2, xStep,
                    wallWidth),
                wallPaint);
          }
        }

        if (x == 11) {
          if (board.hasRightWall(x, y)) {
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
