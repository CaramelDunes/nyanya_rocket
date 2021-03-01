import 'package:flutter/material.dart';

import 'game_view/tiles/pit_painter.dart';

class PitImage extends StatelessWidget {
  const PitImage({Key? key}) : super(key: key);

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
