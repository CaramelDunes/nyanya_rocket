import 'dart:math';
import 'dart:ui' as ui;

import 'package:flare_dart/math/aabb.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/flare_cache_asset.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CachedFlareAnimation {
  static const int fps = 60;

  Size _size;
  List<ui.Image> _cachedPictures;

  CachedFlareAnimation(
      {@required String assetFilename, @required String animationName}) {
    cachedActor(AssetFlare(bundle: rootBundle, name: assetFilename))
        .then((FlareCacheAsset cacheAsset) async {
      FlutterActor actor = cacheAsset.actor;

      FlutterActorArtboard artboard = actor.artboard;
      artboard.initializeGraphics();

      ActorAnimation animation = artboard.getAnimation(animationName);

      if (animation != null) {
        int numberOfFrames = (animation.duration * fps).floor();
        AABB bounds = artboard.artboardAABB();

        _size = Size(bounds[2] - bounds[0], bounds[3] - bounds[1]);

        List<ui.Image> cache = List(numberOfFrames);

        for (int i = 0; i < numberOfFrames; i++) {
          animation.apply(i * animation.duration / numberOfFrames, artboard, 1);
          artboard.advance(0); // The parameter is actually useless

          final pictureRecorder = ui.PictureRecorder();
          ui.Canvas canvas = ui.Canvas(pictureRecorder);

          artboard.draw(canvas); // TODO Make cache building async
          cache[i] = await pictureRecorder
              .endRecording()
              .toImage(_size.width.floor(), _size.height.floor());
        }

        _cachedPictures = cache;
        print('Cached $assetFilename');
      }
    });
  }

  void draw(Canvas canvas, Size size, double x, double y, int frameNb,
      [Paint paint]) {
    if (_cachedPictures != null) {
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
