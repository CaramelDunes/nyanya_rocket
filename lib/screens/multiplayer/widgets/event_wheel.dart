import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class EventWheel extends StatelessWidget {
  final ScrollController scrollController;

  static final List<Widget> cards =
      List.generate((GameEvent.values.length - 1) * 5, (index) {
    return _cardForEvent(
        GameEvent.values[(index % (GameEvent.values.length - 1)) + 1]);
  });

  const EventWheel({Key key, @required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView(
      controller: scrollController,
      physics: NeverScrollableScrollPhysics(),
      children: cards,
      itemExtent: 100,
      squeeze: 1.1,
    );
  }

  static Widget _cardForEvent(GameEvent event) {
    Color cardColor = Colors.black;
    String eventName = 'None';

    switch (event) {
      case GameEvent.CatMania:
        cardColor = Colors.lightBlueAccent;
        eventName = 'Cat Mania';
        break;

      case GameEvent.MouseMania:
        cardColor = Colors.purpleAccent;
        eventName = 'Mouse Mania';
        break;

      case GameEvent.SpeedUp:
        cardColor = Colors.red;
        eventName = 'Speed Up';
        break;

      case GameEvent.SlowDown:
        cardColor = Colors.deepPurpleAccent;
        eventName = 'Slow Down';
        break;

      case GameEvent.MouseMonopoly:
        cardColor = Colors.pinkAccent;
        eventName = 'Mouse Monopoly';
        break;

      case GameEvent.CatAttack:
        cardColor = Colors.green;
        eventName = 'Cat Attack';
        break;

      case GameEvent.PlaceAgain:
        cardColor = Colors.deepOrangeAccent;
        eventName = 'Place Arrows Again';
        break;

      case GameEvent.EverybodyMove:
        cardColor = Colors.yellow;
        eventName = 'Everybody Move!';
        break;

      case GameEvent.None:
      default:
        break;
    }

    return Container(
      color: cardColor,
      child: Center(
          child: Stack(
        children: <Widget>[
          // Stroked text as border.
          Text(
            eventName,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 35,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4
                ..color = Colors.black,
            ),
          ),
          // Solid text as fill.
          Text(
            eventName,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 35,
              color: Colors.white,
            ),
          ),
        ],
      )),
    );
  }
}
