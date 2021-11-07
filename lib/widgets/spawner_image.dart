import 'package:flutter/material.dart';
import 'game_view/tiles/spawner_painter.dart';

class SpawnerImage extends StatelessWidget {
  const SpawnerImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        size: Size.infinite,
        painter: SpawnerPainter(),
      ),
    );
  }
}
