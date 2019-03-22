import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/entities_drawer.dart';
import 'package:nyanya_rocket/widgets/game_view/tiles_drawer.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class General extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Text(
          'Tiles',
          style: Theme.of(context).textTheme.headline,
        ),
        Card(
          child: Container(
              height: 76,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TilesDrawer.tileView(Pit()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Black Hole (technically a square though...)'),
                  )
                ],
              )),
        ),
        Card(
          child: Container(
              height: 76,
              child: Row(
                children: <Widget>[
                  Flexible(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TilesDrawer.tileView(
                            Rocket(player: PlayerColor.Blue)),
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Rocket'),
                    ),
                  ),
                ],
              )),
        ),
        Card(
          child: Container(
              height: 76,
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TilesDrawer.tileView(Arrow(
                          player: PlayerColor.Blue, direction: Direction.Up)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Arrow'),
                    ),
                  ),
                ],
              )),
        ),
        Divider(),
        Text(
          'Entities',
          style: Theme.of(context).textTheme.headline,
        ),
        Card(
          child: Container(
              height: 76,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EntitiesDrawer.entityView(
                        EntityType.Mouse, Direction.Right),
                  )),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Mouse'),
                    ),
                  ),
                ],
              )),
        ),
        Card(
          child: Container(
              height: 76,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EntitiesDrawer.entityView(
                        EntityType.Cat, Direction.Down),
                  )),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Cats are slower than mice.\nWhen a cat meets an arrow head-on, it will damage it or destroy it if already damaged.'),
                    ),
                  ),
                ],
              )),
        ),
        Text("""
An entity walks straight until it encounters an arrow or a wall.
"""),
        Divider(),
        Text(
          'Arrow placement',
          style: Theme.of(context).textTheme.headline,
        ),
        Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Text(
                'Arrows can be drag n\' dropped...',
                textAlign: TextAlign.center,
              )),
              Flexible(child: Image.asset('assets/animations/drag_arrow.gif')),
            ],
          ),
        )),
        Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Text(
                '...or swiped',
                textAlign: TextAlign.center,
              )),
              Flexible(
                  flex: 0,
                  child: Image.asset('assets/animations/swipe_arrow.gif')),
            ],
          ),
        )),
        Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Text(
                'Arrows can be removed by tapping',
                textAlign: TextAlign.center,
              )),
              Flexible(
                  flex: 0,
                  child: Image.asset('assets/animations/remove_arrow.gif')),
            ],
          ),
        )),
      ],
    );
  }
}
