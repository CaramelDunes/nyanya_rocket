import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'unit_painter.dart';

class RivePainter implements UnitPainter {
  int _lastFrameNumber = 0;
  RuntimeArtboard artboard;

  RivePainter._(this.artboard);

  static Future<RivePainter> load(
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

      return RivePainter._(artboard);
    }

    throw Exception("Could not load rive animation");
  }

  void paintUnit(Canvas canvas, int frameNumber, [Paint? paint]) {
    canvas.scale(1 / artboard.width, 1 / artboard.height);

    if (_lastFrameNumber != frameNumber) {
      artboard.advance(0.032);
      _lastFrameNumber = frameNumber;
    }

    artboard.draw(canvas);
  }
}
