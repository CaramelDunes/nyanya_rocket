import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'canvas_rive_animation.dart';

class CachedRiveAnimation implements CanvasRiveAnimation {
  static const int fps = 60;

  Size _size;
  List<ui.Image> _cachedPictures;

  CachedRiveAnimation._(this._size, this._cachedPictures);

  static Future<CachedRiveAnimation> load(
      {required String assetFilename, required String animationName}) async {
    final data = await rootBundle.load(assetFilename);
    final file = RiveFile();

    // Load the RiveFile from the binary data.
    if (file.import(data)) {
      // The artboard is the root of the animation and gets drawn in the
      // Rive widget.
      final artboard = file.mainArtboard as RuntimeArtboard;
      artboard.addController(
        SimpleAnimation('Move'),
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

      return CachedRiveAnimation._(size, cache);
    }

    throw Exception("Could not cache rive animation");
  }

  void draw(Canvas canvas, Size size, double x, double y, int frameNb,
      [Paint? paint]) {
    double scale = min(size.width / _size.width, size.height / _size.height);

    if (scale * _size.height < size.height) {
      y += (size.height - scale * _size.height) / 2;
    } else if (scale * _size.width < size.width) {
      x += (size.width - scale * _size.width) / 2;
    }

    canvas.save();

    canvas.translate(x, y);
    canvas.scale(scale);
    canvas.drawImage(_cachedPictures[frameNb], Offset.zero, paint ?? Paint());

    canvas.restore();
  }
}
