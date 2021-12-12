import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../widgets/board/entities/entity_painter.dart';
import '../../../widgets/board/tiles/tile_painter.dart';

class Multiplayer extends StatelessWidget {
  const Multiplayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Card(
          child: SizedBox(
              height: 76,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TilePainter.widget(
                          const Generator(direction: Direction.Up)),
                    ),
                  ),
                  const Flexible(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(''),
                    ),
                  )
                ],
              )),
        ),
        Card(
          child: SizedBox(
              height: 100,
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EntityPainter.widget(
                        EntityType.SpecialMouse, Direction.Right),
                  )),
                  const Flexible(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(''),
                    ),
                  ),
                ],
              )),
        ),
        Card(
          child: SizedBox(
            height: 100,
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EntityPainter.widget(
                      EntityType.GoldenMouse, Direction.Down),
                )),
                const Flexible(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
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
