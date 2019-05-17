import 'package:flare_flutter/flare_cache.dart';
import 'package:flutter/services.dart';
import 'package:nyanya_rocket/widgets/game_view/entities_drawer_canvas.dart';

// Copied from
// https://github.com/2d-inc/developer_quest/blob/master/lib/src/widgets/flare/warmup_flare.dart

const _filesToWarmUp = [
  "assets/animations/cat_right.flr",
  "assets/animations/cat_up.flr",
  "assets/animations/cat_left.flr",
  "assets/animations/cat_down.flr",
  "assets/animations/mouse_right.flr",
  "assets/animations/mouse_up.flr",
  "assets/animations/mouse_left.flr",
  "assets/animations/mouse_down.flr",
];

/// Ensure all Flare assets used by this app are cached and ready to
/// be displayed as quickly as possible.
Future<void> warmUpFlare() async {
  for (final filename in _filesToWarmUp) {
    print('Warming up $filename');
    await cachedActor(rootBundle, filename);
    await Future<void>.delayed(const Duration(milliseconds: 16));
  }

  EntitiesDrawerCanvas.mouseAnimations;
  EntitiesDrawerCanvas.catAnimations;
}
