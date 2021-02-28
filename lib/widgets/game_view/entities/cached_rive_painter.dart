import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'unit_painter.dart';

class CachedRivePainter implements UnitPainter {
  static const int fps = 60;

  Size _size;
  List<ui.Image> _cachedPictures;

  CachedRivePainter._(this._size, this._cachedPictures);

  static Future<CachedRivePainter> load(
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
      int numberOfFrames = 30;
      Size size = Size(artboard.width * 0.228, artboard.height * 0.228);

      List<ui.Image> cache =
          await Future.wait(List.generate(numberOfFrames, (i) {
        artboard.advance(0.016);

        final pictureRecorder = ui.PictureRecorder();
        ui.Canvas canvas = ui.Canvas(pictureRecorder);
        canvas.scale(0.228);

        artboard.draw(canvas);
        return pictureRecorder.endRecording().toImage(
            (artboard.width * 0.228).floor(),
            (artboard.height * 0.228).floor());
      }));

      return CachedRivePainter._(size, cache);
    }

    throw Exception("Could not cache rive animation");
  }

  void paintUnit(Canvas canvas, int frameNumber, [Paint? paint]) {
    canvas.save();

    canvas.scale(1 / _size.width, 1 / _size.height);
    canvas.drawImage(_cachedPictures[frameNumber], Offset.zero, paint ?? Paint());

    canvas.restore();
  }
}
