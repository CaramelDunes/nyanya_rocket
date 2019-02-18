import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

const List<String> kColorSuffixes = ["blue", "yellow", "red", "green"];

class ArrowImage extends StatelessWidget {
  final PlayerColor player;
  final Direction direction;

  const ArrowImage({Key key, @required this.player, @required this.direction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: -direction.index,
      child: Image.asset(
          'assets/graphics/arrow_${kColorSuffixes[player.index]}.png',
          fit: BoxFit.contain),
    );
  }
}
