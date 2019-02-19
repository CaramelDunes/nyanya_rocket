import 'dart:math';
import 'dart:ui' as ui;

import 'package:flare_dart/math/aabb.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CachedFlareAnimation {
  static const int fps = 60;

  int _currentFrame = 0;
  int _numberOfFrames = 1;
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
          _numberOfFrames = (animation.duration * fps).floor();
          print(_numberOfFrames);
          AABB bounds = artboard.artboardAABB();

          _size = Size(bounds[2] - bounds[0], bounds[3] - bounds[1]);

          List<ui.Image> cache = List.generate(_numberOfFrames, (int i) {
            animation.apply(
                i * animation.duration / _numberOfFrames, artboard, 1);
            artboard.advance(0); // The parameter is actually useless

            final pictureRecorder = ui.PictureRecorder();
            ui.Canvas canvas = ui.Canvas(pictureRecorder);

            artboard.draw(canvas); // TODO Make cache building async

            return pictureRecorder
                .endRecording()
                .toImage(_size.width.floor(), _size.height.floor());
          }, growable: false);

          _cachedPictures = cache;
        }
      }
    });
  }

  void advance() {
    _currentFrame = (_currentFrame + 1) % _numberOfFrames;
  }

  void draw(Canvas canvas, Size size, double x, double y) {
    if (_cachedPictures != null) {
      double scaleX = 1.0, scaleY = 1.0;

      double minScale =
          min(size.width / _size.width, size.height / _size.height);
      scaleX = scaleY = minScale;

      if (scaleY * _size.height < size.height) {
        y += (size.height - scaleY * _size.height) / 2;
      } else if (scaleX * _size.width < size.width) {
        x += (size.width - scaleX * _size.width) / 2;
      }

      canvas.save();

      canvas.translate(x, y);
      canvas.scale(scaleX, scaleY);
      canvas.drawImage(_cachedPictures[_currentFrame], Offset.zero, Paint());

      canvas.restore();
    }
  }
}
