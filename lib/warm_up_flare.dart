import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'widgets/game_view/entities/entities_drawer_canvas.dart';
import 'widgets/game_view/entities/cached_rive_animation.dart';
import 'widgets/game_view/entities/drawable_rive_animation.dart';

/// Ensure all Rive assets used by this app are cached and ready to
/// be displayed as quickly as possible.
Future<void> warmUpFlare() async {
  const String animationName = 'walk';
  const List<String> directions = ['right', 'up', 'left', 'down'];

  // On Web, do not cache frames for better performance.
  const loadFunction =
      kIsWeb ? DrawableRiveAnimation.load : CachedRiveAnimation.load;

  EntitiesDrawerCanvas.mouseAnimations = await Future.wait(List.generate(
      4,
      (index) => loadFunction(
          assetFilename: "assets/animations/mouse.riv",
          animationName: animationName,
          artboardName: directions[index])));

  EntitiesDrawerCanvas.catAnimations = await Future.wait(List.generate(
      4,
      (index) => loadFunction(
          assetFilename: "assets/animations/cat.riv",
          animationName: animationName,
          artboardName: directions[index])));
}
