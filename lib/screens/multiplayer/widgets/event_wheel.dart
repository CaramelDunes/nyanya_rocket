import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class EventWheel extends StatelessWidget {
  final ScrollController scrollController;

  static final List<Widget> cards =
      List.generate((GameEvent.values.length - 1) * 5, (index) {
    return _cardForEvent(
        GameEvent.values[(index % (GameEvent.values.length - 1)) + 1]);
  });

  const EventWheel({Key key, @required this.scrollController}) : super(key: key);

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
    const TextStyle commonStyle = TextStyle(
      fontSize: 30,
      color: Colors.white,
    );

    switch (event) {
      case GameEvent.CatMania:
        return Container(
          color: Colors.lightBlueAccent,
          child: Center(child: Text('Cat Mania', style: commonStyle)),
        );
        break;

      case GameEvent.MouseMania:
        return Container(
          color: Colors.purpleAccent,
          child: Center(child: Text('Mouse Mania', style: commonStyle)),
        );
        break;

      case GameEvent.SpeedUp:
        return Container(
          color: Colors.red,
          child: Center(child: Text('Speed Up', style: commonStyle)),
        );
        break;

      case GameEvent.SlowDown:
        return Container(
          color: Colors.purpleAccent,
          child: Center(child: Text('Slow Down', style: commonStyle)),
        );
        break;

      case GameEvent.MouseMonopoly:
        return Container(
          color: Colors.lightBlueAccent,
          child: Center(child: Text('Mouse Monopoly', style: commonStyle)),
        );
        break;

      case GameEvent.CatAttack:
        return Container(
          color: Colors.lightGreenAccent,
          child: Center(child: Text('Cat Attack', style: commonStyle)),
        );
        break;

      case GameEvent.PlaceAgain:
        return Container(
          color: Colors.deepOrangeAccent,
          child: Center(child: Text('Place Again', style: commonStyle)),
        );
        break;

      case GameEvent.None:
      default:
        return const SizedBox.shrink();
        break;
    }
  }
}
