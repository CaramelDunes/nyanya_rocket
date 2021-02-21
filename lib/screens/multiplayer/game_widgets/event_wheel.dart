import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class EventWheel extends StatelessWidget {
  final ScrollController scrollController;

  static final List<Widget> cards =
      List.generate((GameEvent.values.length - 1) * 5, (index) {
    return _cardForEvent(
        GameEvent.values[(index % (GameEvent.values.length - 1)) + 1]);
  });

  const EventWheel({Key? key, required this.scrollController})
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

      case GameEvent.MouseMania:
        return 'Mouse Mania';

      case GameEvent.SpeedUp:
        return 'Speed Up';

      case GameEvent.SlowDown:
        return 'Slow Down';

      case GameEvent.MouseMonopoly:
        return 'Mouse Monopoly';

      case GameEvent.CatAttack:
        return 'Cat Attack';

      case GameEvent.PlaceAgain:
        return 'Place Arrows Again';

      case GameEvent.EverybodyMove:
        return 'Everybody Move!';

      case GameEvent.None:
        return 'None';
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
