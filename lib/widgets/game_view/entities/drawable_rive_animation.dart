import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'canvas_rive_animation.dart';

class DrawableRiveAnimation implements CanvasRiveAnimation {
  int lastNb = 0;
  RuntimeArtboard artboard;

  DrawableRiveAnimation._(this.artboard);

  static Future<DrawableRiveAnimation> load(
      {required String assetFilename,
      required String animationName,
      String? artboardName}) async {
    final data = await rootBundle.load(assetFilename);
    final file = RiveFile();

    // Load the RiveFile from the binary data.
    if (file.import(data)) {
      // The artboard is the root of the animation and gets drawn in the
      // Rive widget.
      final artboard = (artboardName != null
          ? file.artboardByName(artboardName)
          : file.mainArtboard) as RuntimeArtboard;
      artboard.addController(
        SimpleAnimation(animationName),
      );

      artboard.advance(0);

      return DrawableRiveAnimation._(artboard);
    }

    throw Exception("Could not load rive animation");
  }

  void drawUnit(Canvas canvas, int frameNb, [Paint? paint]) {
    canvas.scale(1 / artboard.width, 1 / artboard.height);

    if (lastNb != frameNb) {
      artboard.advance(0.032);
      lastNb = frameNb;
    }

    artboard.draw(canvas);
  }
}
