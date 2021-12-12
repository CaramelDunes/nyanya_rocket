import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';
import 'rocket_painter.dart';

class RocketImage extends StatelessWidget {
  final PlayerColor? player;
  final bool departed;

  const RocketImage({Key? key, required this.player, this.departed = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: RocketPainter.fromPlayerColor(player, departed),
        size: Size.infinite,
      ),
    );
  }
}
