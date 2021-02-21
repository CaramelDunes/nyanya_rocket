import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:nyanya_rocket/widgets/game_view/cached_rive_animation.dart';
import 'package:nyanya_rocket/widgets/game_view/entities_drawer_canvas.dart';

import 'widgets/game_view/drawable_rive_animation.dart';

/// Ensure all Rive assets used by this app are cached and ready to
/// be displayed as quickly as possible.
Future<void> warmUpFlare() async {
  const List<String> _directions = ['right', 'up', 'left', 'down'];

  // On Web, do not cache frames as images for better performance.
  if (kIsWeb) {
    EntitiesDrawerCanvas.mouseAnimations = [
      await DrawableRiveAnimation.load(
          assetFilename: "assets/animations/mouse_${_directions[0]}.riv",
          animationName: "Move"),
      await DrawableRiveAnimation.load(
          assetFilename: "assets/animations/mouse_${_directions[1]}.riv",
          animationName: "Move"),
      await DrawableRiveAnimation.load(
          assetFilename: "assets/animations/mouse_${_directions[2]}.riv",
          animationName: "Move"),
      await DrawableRiveAnimation.load(
          assetFilename: "assets/animations/mouse_${_directions[3]}.riv",
          animationName: "Move")
    ];

    EntitiesDrawerCanvas.catAnimations = [
      await DrawableRiveAnimation.load(
          assetFilename: "assets/animations/cat_${_directions[0]}.riv",
          animationName: "Move"),
      await DrawableRiveAnimation.load(
          assetFilename: "assets/animations/cat_${_directions[1]}.riv",
          animationName: "Move"),
      await DrawableRiveAnimation.load(
          assetFilename: "assets/animations/cat_${_directions[2]}.riv",
          animationName: "Move"),
      await DrawableRiveAnimation.load(
          assetFilename: "assets/animations/cat_${_directions[3]}.riv",
          animationName: "Move")
    ];
  } else {
    EntitiesDrawerCanvas.mouseAnimations = [
      await CachedRiveAnimation.load(
          assetFilename: "assets/animations/mouse_${_directions[0]}.riv",
          animationName: "Move"),
      await CachedRiveAnimation.load(
          assetFilename: "assets/animations/mouse_${_directions[1]}.riv",
          animationName: "Move"),
      await CachedRiveAnimation.load(
          assetFilename: "assets/animations/mouse_${_directions[2]}.riv",
          animationName: "Move"),
      await CachedRiveAnimation.load(
          assetFilename: "assets/animations/mouse_${_directions[3]}.riv",
          animationName: "Move")
    ];

    EntitiesDrawerCanvas.catAnimations = [
      await CachedRiveAnimation.load(
          assetFilename: "assets/animations/cat_${_directions[0]}.riv",
          animationName: "Move"),
      await CachedRiveAnimation.load(
          assetFilename: "assets/animations/cat_${_directions[1]}.riv",
          animationName: "Move"),
      await CachedRiveAnimation.load(
          assetFilename: "assets/animations/cat_${_directions[2]}.riv",
          animationName: "Move"),
      await CachedRiveAnimation.load(
          assetFilename: "assets/animations/cat_${_directions[3]}.riv",
          animationName: "Move")
    ];
  }
}
