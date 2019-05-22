import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/arrow_image.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

const List<String> kColorSuffixes = ["blue", "yellow", "red", "green"];

class TilesDrawer extends StatelessWidget {
  final Board board;
  final BoxConstraints constraints;

  static Widget tileView(Tile tile) {
    switch (tile.runtimeType) {
      case Pit:
        return Image.asset(
          'assets/graphics/pit.png',
          fit: BoxFit.contain,
        );
        break;

      case Generator:
        return Image.asset('assets/graphics/generator.png',
            fit: BoxFit.contain);
        break;

      case Arrow:
        Arrow arrow = tile as Arrow;

        if (arrow.expiration > 120 || arrow.expiration % 20 < 10) {
          return Transform.scale(
            scale: arrow.halfTurnPower == ArrowHalfTurnPower.TwoCats ? 1 : 0.5,
            child: ArrowImage(player: arrow.player, direction: arrow.direction),
          );
        } else {
          return const SizedBox.expand();
        }
        break;

      case Rocket:
        Rocket rocket = tile as Rocket;

        if (!rocket.departed) {
          return Image.asset(
              'assets/graphics/rocket_${kColorSuffixes[rocket.player.index]}.png',
              fit: BoxFit.contain);
        } else {
          return Image.asset('assets/graphics/departed_rocket.png',
              fit: BoxFit.contain);
        }
        break;

      default:
        return Container(
          color: Colors.transparent,
        );
    }
  }

  TilesDrawer(this.board, this.constraints);

  @override
  Widget build(BuildContext context) {
    List<Widget> overlay = List();

    for (int x = 0; x < Board.width; x++) {
      for (int y = 0; y < Board.height; y++) {
        if (board.tiles[x][y] is! Empty) {
          overlay.add(Positioned(
              top: y * constraints.maxHeight / 9,
              left: x * constraints.maxWidth / 12,
              width: constraints.maxWidth / 12,
              height: constraints.maxHeight / 9,
              child: tileView(board.tiles[x][y])));
        }
      }
    }

    return Stack(children: overlay);
  }
}
