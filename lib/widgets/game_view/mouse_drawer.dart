import 'dart:math';
import 'dart:ui' as ui;

import 'package:flare_dart/math/aabb.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class MouseDrawer {
  static List<FlutterActorArtboard> _artboards;
  static List<ActorAnimation> _animationLayers;
  static final List<String> _directions = ['right', 'up', 'left', 'down'];
  static final List<ui.Image> _rasters = List(4);
  static final List<ui.Picture> _pictures = List(4);

  static void setAnim(double time) {
    if (_animationLayers == null ||
        _animationLayers[0] == null ||
        _animationLayers[1] == null ||
        _animationLayers[2] == null ||
        _animationLayers[3] == null) return;

    _animationLayers[0]
        .apply(time % _animationLayers[0].duration, _artboards[0], 0.5);
    _artboards[0].advance(0);

    _animationLayers[1]
        .apply(time % _animationLayers[1].duration, _artboards[1], 0.5);
    _artboards[1].advance(0);

    _animationLayers[2]
        .apply(time % _animationLayers[2].duration, _artboards[2], 0.5);
    _artboards[2].advance(0);

    _animationLayers[3]
        .apply(time % _animationLayers[3].duration, _artboards[3], 0.5);
    _artboards[3].advance(0);

    for (int i = 0; i < 4; i++) {
      final pictureRecorder = new ui.PictureRecorder();
      Canvas canvas = new Canvas(pictureRecorder);
      _artboards[i].draw(canvas);
      _pictures[i] = pictureRecorder.endRecording();
      _rasters[i] = null;
    }
  }

  static void draw(
      Canvas canvas, Size size, double x, double y, Direction direction,
      [bool isGolden = false]) {
    if (_pictures != null && _pictures[direction.index] != null) {
      AABB _bounds = _artboards[direction.index].artboardAABB();
      double contentWidth = _bounds[2] - _bounds[0];
      double contentHeight = _bounds[3] - _bounds[1];

      double scaleX = 1.0, scaleY = 1.0;
      _rasters[direction.index] ??= _pictures[direction.index]
          .toImage(contentWidth.ceil(), contentHeight.ceil());

      canvas.save();

      double minScale =
          min(size.width / contentWidth, size.height / contentHeight);
      scaleX = scaleY = minScale;

      if (scaleY * contentHeight < size.height) {
        y += (size.height - scaleY * contentHeight) / 2;
      } else if (scaleX * contentWidth < size.width) {
        x += (size.width - scaleX * contentWidth) / 2;
      }

      canvas.translate(x, y);
      canvas.scale(scaleX, scaleY);

      Paint p = Paint();
      if (isGolden) {
        p.colorFilter = ColorFilter.mode(Colors.yellow, BlendMode.overlay);
      }

      canvas.drawImage(_rasters[direction.index], Offset(0, 0), p);
      canvas.restore();
    } else {
      print('And again');
      _artboards = List(4);
      _animationLayers = List(4);

      for (int i = 0; i < 4; i++) {
        FlutterActor actor = FlutterActor();
        actor
            .loadFromBundle(rootBundle,
                "assets/animations/mouse_${_directions[i]}.flr") // FIXME Don't use rootBundle
            .then((bool success) {
          if (success && actor != null) {
            FlutterActorArtboard artboard = actor.artboard;
            artboard.initializeGraphics();
            artboard.advance(0.0);
            _artboards[i] = artboard;

            ActorAnimation animation = artboard.getAnimation("Move");

            if (animation != null) {
              _animationLayers[i] = animation;
              animation.apply(0.0, artboard, 1.0);
              artboard.advance(0.0);
            }
          }

          final pictureRecorder = new ui.PictureRecorder();
          Canvas canvas = new Canvas(pictureRecorder);
          _artboards[i].draw(canvas);
          _pictures[i] = pictureRecorder.endRecording();
          _rasters[i] = null;
        });
      }
    }
  }
}
