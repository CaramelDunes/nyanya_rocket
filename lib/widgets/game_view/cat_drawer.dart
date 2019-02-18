import 'dart:math';

import 'package:flare_dart/math/aabb.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class CatDrawer {
  static List<FlutterActorArtboard> _artboards;
  static List<ActorAnimation> _animationLayers;
  static AABB _bounds;
  static final List<String> _directions = ['right', 'up', 'left', 'down'];

  static void setAnim(double time) {
    if (_animationLayers == null ||
        _animationLayers[0] == null ||
        _animationLayers[1] == null ||
        _animationLayers[2] == null ||
        _animationLayers[3] == null) return;

    _animationLayers[0]
        .apply(time % _animationLayers[0].duration, _artboards[0], 0.5);
    _artboards[0].advance(0.016);

    _animationLayers[1]
        .apply(time % _animationLayers[1].duration, _artboards[1], 0.5);
    _artboards[1].advance(0.016);

    _animationLayers[2]
        .apply(time % _animationLayers[2].duration, _artboards[2], 0.5);
    _artboards[2].advance(0.016);

    _animationLayers[3]
        .apply(time % _animationLayers[3].duration, _artboards[3], 0.5);
    _artboards[3].advance(0.016);
  }

  static void draw(
      Canvas canvas, Size size, double x, double y, Direction direction) {
    if (_artboards != null && _artboards[direction.index] != null) {
      double contentWidth = _bounds[2] - _bounds[0];
      double contentHeight = _bounds[3] - _bounds[1];

      double scaleX = 1.0, scaleY = 1.0;

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

      _artboards[direction.index].draw(canvas);
      canvas.restore();
    } else {
      _artboards = List(4);
      _animationLayers = List(4);

      for (int i = 0; i < 4; i++) {
        FlutterActor actor = FlutterActor();
        actor
            .loadFromBundle(
                rootBundle, "assets/animations/cat_${_directions[i]}.flr")
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

          _bounds = _artboards[0].artboardAABB();
        });
      }
    }
  }
}
