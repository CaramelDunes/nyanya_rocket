import 'package:flutter/material.dart';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../localization/nyanya_localizations.dart';
import '../../../widgets/arrow_image.dart';
import '../../../widgets/game_view/entities/entity_painter.dart';
import '../../../widgets/game_view/tiles/tile_painter.dart';
import '../../../widgets/pit_image.dart';

class General extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        Text(
          NyaNyaLocalizations.of(context).tilesTutorialLabel,
          style: Theme.of(context).textTheme.headline5,
        ),
        Card(
          child: Container(
              height: 76,
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const PitImage(),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text(NyaNyaLocalizations.of(context).pitTutorialText),
                    ),
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
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TilePainter.widget(Rocket(player: PlayerColor.Blue)),
                  )),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          NyaNyaLocalizations.of(context).rocketTutorialText),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ArrowImage(
                        player: PlayerColor.Blue,
                        direction: Direction.Up,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          NyaNyaLocalizations.of(context).arrowTutorialText),
                    ),
                  ),
                ],
              )),
        ),
        Divider(),
        Text(
          NyaNyaLocalizations.of(context).entitiesTutorialLabel,
          style: Theme.of(context).textTheme.headline5,
        ),
        Card(
          child: Container(
              height: 100,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        EntityPainter.widget(EntityType.Mouse, Direction.Right),
                  ),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          NyaNyaLocalizations.of(context).mouseTutorialText),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EntityPainter.widget(EntityType.Cat, Direction.Down),
                ),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Text(NyaNyaLocalizations.of(context).catTutorialText),
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          NyaNyaLocalizations.of(context).movementTutorialText,
          textAlign: TextAlign.center,
        ),
        Divider(),
        Text(
          NyaNyaLocalizations.of(context).placementTutorialLabel,
          style: Theme.of(context).textTheme.headline5,
        ),
        Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  child: Text(
                NyaNyaLocalizations.of(context).arrowDnDTutorialText,
                textAlign: TextAlign.center,
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/animations/drag_arrow.gif'),
              ),
            ],
          ),
        )),
        Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  child: Text(
                NyaNyaLocalizations.of(context).arrowSwipeTutorialText,
                textAlign: TextAlign.center,
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/animations/swipe_arrow.gif'),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
