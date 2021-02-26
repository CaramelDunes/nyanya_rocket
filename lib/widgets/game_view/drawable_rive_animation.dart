import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'canvas_rive_animation.dart';

class DrawableRiveAnimation implements CanvasRiveAnimation {
  int lastNb = 0;
  RuntimeArtboard artboard;

  DrawableRiveAnimation._(this.artboard);

  static Future<DrawableRiveAnimation> load(
      {required String assetFilename, required String animationName}) async {
    final data = await rootBundle.load(assetFilename);
    final file = RiveFile();

    // Load the RiveFile from the binary data.
    if (file.import(data)) {
      // The artboard is the root of the animation and gets drawn in the
      // Rive widget.
      final artboard = file.mainArtboard as RuntimeArtboard;
      artboard.addController(
        SimpleAnimation(animationName),
      );

      artboard.advance(0);

      return DrawableRiveAnimation._(artboard);
    }

    throw Exception("Could not load rive animation");
  }

  void draw(Canvas canvas, Size size, double x, double y, int frameNb,
      [Paint? paint]) {
    double scale =
        min(size.width / artboard.width, size.height / artboard.height);

    if (scale * artboard.height < size.height) {
      y += (size.height - scale * artboard.height) / 2;
    } else if (scale * artboard.width < size.width) {
      x += (size.width - scale * artboard.width) / 2;
    }

    canvas.save();

    canvas.translate(x, y);
    canvas.scale(scale);

    if (lastNb != frameNb) {
      artboard.advance(0.032);
      lastNb = frameNb;
    }

    artboard.draw(canvas);

    canvas.restore();
  }
}
