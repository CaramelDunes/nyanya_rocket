import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

const List<String> kColorSuffixes = ["blue", "red", "yellow", "green"];

class TileView extends StatelessWidget {
  final Tile tile;

  TileView(this.tile);

  @override
  Widget build(BuildContext context) {
    switch (tile.runtimeType) {
      case Pit:
        return Image(image: AssetImage("assets/graphics/pit.png"));
        break;

      case Generator:
        return Image(image: AssetImage("assets/graphics/generator.png"));
        break;

      case Arrow:
        Arrow arrow = tile as Arrow;
        return RotatedBox(
          quarterTurns: arrow.direction.index - 3,
          child: Image(
              image: AssetImage(
                  "assets/graphics/arrow_${kColorSuffixes[arrow.owner.index]}.png")),
        );
        break;

      case Rocket:
        Rocket rocket = tile as Rocket;
        return Image(
            image: AssetImage(
                "assets/graphics/rocket_${kColorSuffixes[rocket.owner.index]}.png"));
        break;

      default:
        return Container(
          color: Colors.transparent,
        );
    }
  }
}
