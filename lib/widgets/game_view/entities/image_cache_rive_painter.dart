import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import '../../../utils.dart';
import 'unit_painter.dart';

class ImageCacheRivePainter implements UnitPainter {
  static const int numberOfFrames = 30;
  static const double rasterizeRatio = 0.228;

  final Size _size;
  final List<ui.Image> _cachedPictures;

  ImageCacheRivePainter._(this._size, this._cachedPictures);

  static Future<ImageCacheRivePainter> load(
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

    final Size size =
        Size(artboard.width * rasterizeRatio, artboard.height * rasterizeRatio);

    final List<ui.Image> cache =
        await Future.wait(List.generate(numberOfFrames, (i) {
      artboard.advance(0.016);

      final ui.Picture picture = createPicture((canvas) {
        canvas.scale(rasterizeRatio);
        artboard.draw(canvas);
      });

      return picture.toImage((artboard.width * rasterizeRatio).floor(),
          (artboard.height * rasterizeRatio).floor());
    }));

    return ImageCacheRivePainter._(size, cache);
  }

  @override
  void paintUnit(Canvas canvas, int frameNumber, [Paint? paint]) {
    canvas.save();

    canvas.scale(1 / _size.width, 1 / _size.height);
    canvas.drawImage(
        _cachedPictures[frameNumber], Offset.zero, paint ?? Paint());

    canvas.restore();
  }
}
