import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/rocket_painter.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

const List<String> kColorSuffixes = ['blue', 'red', 'green', 'yellow', 'grey'];

class RocketImage extends StatelessWidget {
  final PlayerColor? player;

  const RocketImage({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: RocketPainter.fromPlayerColor(player),
        size: Size.infinite,
      ),
    );
  }
}
