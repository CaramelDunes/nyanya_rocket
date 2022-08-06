import 'package:flutter/material.dart';

import 'pit_painter.dart';

class PitImage extends StatelessWidget {
  const PitImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        size: Size.infinite,
        painter: PitPainter(),
      ),
    );
  }
}
