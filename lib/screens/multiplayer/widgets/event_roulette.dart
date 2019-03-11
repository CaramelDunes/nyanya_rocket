import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class EventRoulette extends StatelessWidget {
  final GameEvent finalEvent;
  final Animation<int> _animation;
  final AnimationController animationController;

  EventRoulette(
      {Key key, @required this.finalEvent, @required this.animationController})
      : _animation = IntTween(
                begin: finalEvent.index - 1,
                // We don't want None to be part of the roulette
                end: 3 * (GameEvent.values.length - 1) + finalEvent.index - 1)
            .animate(CurvedAnimation(
                parent: animationController, curve: Curves.easeOutQuint)),
        super(key: key);

  Widget _cardForEvent(GameEvent event) {
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
        return Container();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget child) {
        // We don't want None to be part of the roulette
        return _cardForEvent(GameEvent
            .values[1 + _animation.value % (GameEvent.values.length - 1)]);
      },
    );
  }
}
