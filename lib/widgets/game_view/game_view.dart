import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/services.dart' show AssetBundle;
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/entity_view.dart';
import 'package:nyanya_rocket/widgets/game_view/tile_view.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

Future<ui.Image> _fetchToMemory(String name, AssetBundle bundle) async {
  ByteData data = await bundle.load(name);
  Uint8List bytes = new Uint8List.view(data.buffer);
  return decodeImageFromList(bytes);
}

bool kImagesLoaded = false;
ui.Image kPitImage;
List<ui.Image> kRocketImages = List(4);
List<ui.Image> kArrowImages = List(4);

const List<String> kColorSuffixes = ["blue", "red", "yellow", "green"];

class GameView extends StatelessWidget {
  final Game game;

  GameView(this.game);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      List<Widget> entities = List();

      game.entities.forEach((int key, Entity value) {
        entities.add(EntityView(value, constraints));
      });

      return CustomPaint(
        painter: BoardPainter(),
        child: Stack(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List<Widget>.generate(
                Board.width,
                (x) => Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List<Widget>.generate(
                          Board.height,
                          (y) => Expanded(
                              child: TileView(game.board.tiles[x][y]))),
                    ))),
          ),
        ] + entities),
      );
    });
  }

  void _loadImages(AssetBundle bundle) async {
    if (kPitImage == null) {
      kPitImage = await _fetchToMemory("assets/graphics/pit.png", bundle);
    }

    for (int i = 0; i < 4; i++) {
      if (kRocketImages[i] == null) {
        kRocketImages[i] = await _fetchToMemory(
            "assets/graphics/rocket_${kColorSuffixes[i]}.png", bundle);
      }

      if (kArrowImages[i] == null) {
        kArrowImages[i] = await _fetchToMemory(
            "assets/graphics/arrow_${kColorSuffixes[i]}.png", bundle);
      }
    }
  }
}

class BoardPainter extends CustomPainter {
  static const Color beigeColor = Color(0xFFF9D0A2);
  static const Color purpleColor = Color(0xFFAC93F1);

  BoardPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _paintBoard(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void _paintBoard(Canvas canvas, Size size) {
    List<Paint> paints = [Paint(), Paint()];
    paints[0].color = purpleColor;
    paints[1].color = beigeColor;

    double xStep = size.width / 12;
    double yStep = size.height / 9;

    for (int x = 0; x < 12; x++) {
      for (int y = 0; y < 9; y++) {
        canvas.drawRect(Rect.fromLTWH(xStep * x, yStep * y, xStep, yStep),
            paints[(x ^ y) & 1]);
      }
    }
  }
}
