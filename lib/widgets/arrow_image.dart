import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'game_view/tiles/arrow_painter.dart';

class ArrowImage extends StatelessWidget {
  final PlayerColor? player;
  final Direction direction;
  final bool damaged;
  final bool isHalfTransparent;

  const ArrowImage(
      {Key? key,
      required this.player,
      required this.direction,
      this.damaged = false,
      this.isHalfTransparent = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget arrow = CustomPaint(
      size: Size.infinite,
      painter: ArrowPainter.fromPlayerColor(player, direction),
    );

    if (isHalfTransparent) {
      return AspectRatio(
        aspectRatio: 1,
        child: Opacity(
          opacity: 0.5,
          child: arrow,
        ),
      );
    }

    return AspectRatio(aspectRatio: 1, child: arrow);
  }
}
