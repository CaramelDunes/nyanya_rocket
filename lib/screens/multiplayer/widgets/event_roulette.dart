import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class EventRoulette extends StatefulWidget {
  final GameEvent finalEvent;

  const EventRoulette({Key key, this.finalEvent}) : super(key: key);

  @override
  _EventRouletteState createState() => _EventRouletteState();
}

class _EventRouletteState extends State<EventRoulette>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;
  Animation<int> _intVersion;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    _animation = CurveTween(curve: Curves.easeOutQuint).animate(_controller);

    _intVersion = IntTween(
            begin: widget.finalEvent.index - 1,
            // We don't want None to be part of the roulette
            end:
                3 * (GameEvent.values.length - 1) + widget.finalEvent.index - 1)
        .animate(_animation);
    _controller.forward();
  }

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
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _intVersion,
      builder: (BuildContext context, Widget child) {
        return _cardForEvent(GameEvent
            // We don't want None to be part of the roulette
            .values[1 + _intVersion.value % (GameEvent.values.length - 1)]);
      },
    );
  }
}
