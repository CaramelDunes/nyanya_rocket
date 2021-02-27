import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'game_view/tiles/arrow_painter.dart';

class ArrowImage extends StatelessWidget {
  final PlayerColor? player;
  final Direction direction;
  final bool opaque;

  const ArrowImage(
      {Key? key,
      required this.player,
      required this.direction,
      this.opaque = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1 - direction.index,
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(
          painter: ArrowPainter.fromPlayerColor(player),
          size: Size.infinite,
        ),
      ),
    );
  }
}
