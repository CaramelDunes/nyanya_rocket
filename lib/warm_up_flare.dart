import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'widgets/game_view/entities/entity_painter.dart';
import 'widgets/game_view/entities/cached_rive_painter.dart';
import 'widgets/game_view/entities/rive_painter.dart';
import 'widgets/game_view/entities/simple_painter.dart';

/// Ensure all Rive assets used by this app are cached and ready to
/// be displayed as quickly as possible.
Future<void> warmUpFlare() async {
  const String animationName = 'walk';
  const List<String> directions = ['right', 'up', 'left', 'down'];

  // On Web, do not cache frames for better performance.
  const loadFunction = kIsWeb ? RivePainter.load : CachedRivePainter.load;

  EntityPainter.mouseAnimations = await Future.wait(directions.map(
      (direction) => loadFunction(
          assetFilename: "assets/animations/mouse.riv",
          animationName: animationName,
          artboardName: direction)));

  EntityPainter.catAnimations = await Future.wait(directions.map((direction) =>
      loadFunction(
          assetFilename: "assets/animations/cat.riv",
          animationName: animationName,
          artboardName: direction)));
}
