import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../widgets/game_view/entities/entity_painter.dart';
import '../../../widgets/game_view/tiles/tile_painter.dart';

class Multiplayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        Card(
          child: Container(
              height: 76,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TilePainter.widget(
                          Generator(direction: Direction.Up)),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(''),
                    ),
                  )
                ],
              )),
        ),
        Card(
          child: Container(
              height: 100,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EntityPainter.widget(
                        EntityType.SpecialMouse, Direction.Right),
                  )),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(''),
                    ),
                  ),
                ],
              )),
        ),
        Card(
          child: Container(
            height: 100,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EntityPainter.widget(
                      EntityType.GoldenMouse, Direction.Down),
                )),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(''),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
