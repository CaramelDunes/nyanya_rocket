import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import '../../../utils.dart';
import 'unit_painter.dart';

class PictureCacheRivePainter implements UnitPainter {
  final List<ui.Picture> _cachedPictures;

  PictureCacheRivePainter._(this._cachedPictures);

  static Future<PictureCacheRivePainter> load(
      {required String assetFilename,
      required String animationName,
      String? artboardName}) async {
    final data = await rootBundle.load(assetFilename);

    // Load the RiveFile from the binary data.
    final file = RiveFile.import(data);

    // The artboard is the root of the animation and gets drawn in the
    // Rive widget.
    final artboard = (artboardName != null
        ? file.artboardByName(artboardName)
        : file.mainArtboard) as RuntimeArtboard;
    artboard.addController(
      SimpleAnimation(animationName),
    );
    int numberOfFrames = 30;

    List<ui.Picture> cache = List.generate(numberOfFrames, (i) {
      artboard.advance(0.016);

      return createPicture((canvas) {
        canvas.scale(1 / artboard.width, 1 / artboard.height);
        artboard.draw(canvas);
      });
    });

    return PictureCacheRivePainter._(cache);
  }

  @override
  void paintUnit(Canvas canvas, int frameNumber, [Paint? paint]) {
    if (paint != null) {
      canvas.saveLayer(const Rect.fromLTRB(0, 0, 1, 1), paint);
    }
    canvas.drawPicture(_cachedPictures[frameNumber]);
    if (paint != null) {
      canvas.restore();
    }
  }
}
