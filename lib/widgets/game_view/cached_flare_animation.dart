import 'dart:math';
import 'dart:ui' as ui;

import 'package:flare_dart/math/aabb.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CachedFlareAnimation {
  static const int fps = 60;

  Size _size;
  List<ui.Image> _cachedPictures;

  CachedFlareAnimation(
      {@required String assetFilename, @required String animationName}) {
    FlutterActor actor = FlutterActor();
    actor.loadFromBundle(rootBundle, assetFilename).then((bool success) {
      if (success && actor != null) {
        FlutterActorArtboard artboard = actor.artboard;
        artboard.initializeGraphics();

        ActorAnimation animation = artboard.getAnimation(animationName);

        if (animation != null) {
          int numberOfFrames = (animation.duration * fps).floor();
          AABB bounds = artboard.artboardAABB();

          _size = Size(bounds[2] - bounds[0], bounds[3] - bounds[1]);

          List<ui.Image> cache = List.generate(numberOfFrames, (int i) {
            animation.apply(
                i * animation.duration / numberOfFrames, artboard, 1);
            artboard.advance(0); // The parameter is actually useless

            final pictureRecorder = ui.PictureRecorder();
            ui.Canvas canvas = ui.Canvas(pictureRecorder);

            artboard.draw(canvas); // TODO Make cache building async
            pictureRecorder
                .endRecording()
                .toImage(_size.width.floor(), _size.height.floor())
                .then((ui.Image img) {
              _cachedPictures[i] = img;
            });
          }, growable: false);

          _cachedPictures = cache;
        }
      }
    });
  }

  void draw(Canvas canvas, Size size, double x, double y, int frameNb,
      [Paint paint]) {
    if (_cachedPictures != null && _cachedPictures[frameNb] != null) {
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
}
