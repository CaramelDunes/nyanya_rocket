import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'widgets/board/entities/entity_painter.dart';
import 'widgets/board/entities/image_cache_rive_painter.dart';
import 'widgets/board/entities/picture_cache_rive_painter.dart';
import 'widgets/board/entities/simple_painter.dart';

/// Ensure all Rive assets used by this app are cached and ready to
/// be displayed as quickly as possible.
Future<void> warmUpFlare() async {
  const String animationName = 'walk';
  const List<String> directions = ['right', 'up', 'left', 'down'];
  const uglyButFastMode = false;

  if (uglyButFastMode) {
    EntityPainter.mouseAnimations =
        List.generate(4, (index) => SimplePainter(Colors.white));

    EntityPainter.catAnimations =
        List.generate(4, (index) => SimplePainter(Colors.orange));
    return;
  }

  // On mobile phones, cache Rive animations as images for better performance.
  // Platform.operatingSystem is undefined on Web, shield its access.
  final loadFunction = !kIsWeb && (Platform.isAndroid || Platform.isIOS)
      ? ImageCacheRivePainter.load
      : PictureCacheRivePainter.load;

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
