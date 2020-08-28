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

  static String eventName(GameEvent event) {
    switch (event) {
      case GameEvent.CatMania:
        return 'Cat Mania';
        break;

      case GameEvent.MouseMania:
        return 'Mouse Mania';
        break;

      case GameEvent.SpeedUp:
        return 'Speed Up';
        break;

      case GameEvent.SlowDown:
        return 'Slow Down';
        break;

      case GameEvent.MouseMonopoly:
        return 'Mouse Monopoly';
        break;

      case GameEvent.CatAttack:
        return 'Cat Attack';
        break;

      case GameEvent.PlaceAgain:
        return 'Place Arrows Again';
        break;

      case GameEvent.EverybodyMove:
        return 'Everybody Move!';
        break;

      case GameEvent.None:
      default:
        return 'None';
        break;
    }
  }

  static Widget _cardForEvent(GameEvent event) {
    Color cardColor = Colors.black;
    String name = eventName(event);

    switch (event) {
      case GameEvent.CatMania:
        cardColor = Colors.lightBlueAccent;
        break;

      case GameEvent.MouseMania:
        cardColor = Colors.purpleAccent;
        break;

      case GameEvent.SpeedUp:
        cardColor = Colors.red;
        break;

      case GameEvent.SlowDown:
        cardColor = Colors.deepPurpleAccent;
        break;

      case GameEvent.MouseMonopoly:
        cardColor = Colors.pinkAccent;
        break;

      case GameEvent.CatAttack:
        cardColor = Colors.green;
        break;

      case GameEvent.PlaceAgain:
        cardColor = Colors.deepOrangeAccent;
        break;

      case GameEvent.EverybodyMove:
        cardColor = Colors.yellow;
        break;

      case GameEvent.None:
      default:
        break;
    }

    return Container(
      color: cardColor,
      child: Center(
          child: Text(
        name,
        style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: 35,
          color: Colors.white,
        ),
      )),
    );
  }
}
