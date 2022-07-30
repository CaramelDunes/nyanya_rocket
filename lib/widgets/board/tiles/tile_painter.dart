import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'arrow_image.dart';
import 'rocket_image.dart';
import 'pit_image.dart';
import 'spawner_image.dart';
import 'arrow_painter.dart';
import 'pit_painter.dart';
import 'rocket_painter.dart';
import '../../../utils.dart';
import 'spawner_painter.dart';

class TilePainter extends StatelessWidget {
  final Board board;
  final BoxConstraints constraints;

  static Widget widget(Tile tile) {
    switch (tile.runtimeType) {
      case Pit:
        return const PitImage();

      case Generator:
        return const SpawnerImage();

      case Arrow:
        Arrow arrow = tile as Arrow;
        return ArrowImage(
            player: arrow.player,
            direction: arrow.direction,
            isDamaged: arrow.halfTurnPower == ArrowHalfTurnPower.OneCat);

      case Rocket:
        Rocket rocket = tile as Rocket;

        return RocketImage(
          player: rocket.player,
          departed: rocket.departed,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  const TilePainter(this.board, this.constraints, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> overlay = [];

    for (int x = 0; x < Board.width; x++) {
      for (int y = 0; y < Board.height; y++) {
        if (board.tiles[x][y] is! Empty) {
          overlay.add(Positioned(
              top: y * constraints.maxHeight / 9,
              left: x * constraints.maxWidth / 12,
              width: constraints.maxWidth / 12,
              height: constraints.maxHeight / 9,
              child: widget(board.tiles[x][y])));
        }
      }
    }

    return Stack(children: overlay);
  }

  static paintUnitTiles(Board board, Canvas canvas) {
    for (int x = 0; x < Board.width; x++) {
      for (int y = 0; y < Board.height; y++) {
        Tile tile = board.tiles[x][y];
        if (tile is Empty) continue;

        canvas.save();
        canvas.translate(x.toDouble(), y.toDouble());
        paintUnitTile(tile, canvas);
        canvas.restore();
      }
    }
  }

  static paintUnitNonArrowTiles(Board board, Canvas canvas) {
    for (int x = 0; x < Board.width; x++) {
      for (int y = 0; y < Board.height; y++) {
        Tile tile = board.tiles[x][y];
        if (tile is Empty || tile is Arrow) continue;

        canvas.save();
        canvas.translate(x.toDouble(), y.toDouble());
        paintUnitTile(tile, canvas);
        canvas.restore();
      }
    }
  }

  static paintUnitArrowTiles(Board board, Canvas canvas) {
    for (int x = 0; x < Board.width; x++) {
      for (int y = 0; y < Board.height; y++) {
        Tile tile = board.tiles[x][y];
        if (tile is! Arrow) continue;

        canvas.save();
        canvas.translate(x.toDouble(), y.toDouble());
        paintUnitTile(tile, canvas);
        canvas.restore();
      }
    }
  }

  static paintUnitTile(Tile tile, Canvas canvas) {
    switch (tile.runtimeType) {
      case Pit:
        PitPainter.paintUnit(canvas);
        break;

      case Arrow:
        Arrow arrow = tile as Arrow;

        // Make arrow blink 1 second (120 ticks) before expiration.
        if (arrow.expiration > 120 || arrow.expiration % 20 < 10) {
          ArrowPainter.paintUnit(canvas, arrow.player.color, arrow.direction,
              arrow.halfTurnPower == ArrowHalfTurnPower.OneCat);
        }
        break;

      case Rocket:
        Rocket rocket = tile as Rocket;
        RocketPainter.paintUnit(canvas, rocket.player.color, rocket.departed);
        break;

      case Generator:
        SpawnerPainter.paintUnit(canvas);
        break;
    }
  }
}
