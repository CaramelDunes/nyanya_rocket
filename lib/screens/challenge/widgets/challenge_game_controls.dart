import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/challenge/challenge_game_controller.dart';

class ChallengeGameControls extends StatefulWidget {
  final ChallengeGameController challengeController;
  ChallengeGameControls({this.challengeController});

  @override
  _ChallengeGameControlsState createState() => _ChallengeGameControlsState();
}

class _ChallengeGameControlsState extends State<ChallengeGameControls> {
  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Expanded(
            child: IconButton(
              icon: Icon(Icons.restore),
              onPressed: () {
                setState(() {
                  widget.challengeController.pleaseReset();
                });
              },
            ),
          ),
        ],
      );
}
