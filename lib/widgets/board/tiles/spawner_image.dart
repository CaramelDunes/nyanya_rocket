import 'package:flutter/material.dart';
import 'spawner_painter.dart';

class SpawnerImage extends StatelessWidget {
  const SpawnerImage({super.key});

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
