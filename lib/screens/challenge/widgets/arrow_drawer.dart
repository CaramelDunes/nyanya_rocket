import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/challenge/challenge_game_controller.dart';
import 'package:nyanya_rocket/widgets/arrow_image.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class ArrowDrawer extends StatelessWidget {
  final ChallengeGameController challengeGameController;

  const ArrowDrawer({Key key, @required this.challengeGameController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        children: List<Widget>.generate(
            4,
            (i) => Expanded(
                  child: Card(
                      child: Draggable<Direction>(
                          maxSimultaneousDrags:
                              challengeGameController.running ? null : 0,
                          feedback: Container(),
                          child: ArrowImage(
                              player: PlayerColor.Blue,
                              direction: Direction.values[i]),
                          data: Direction.values[i])),
                )));
  }
}
