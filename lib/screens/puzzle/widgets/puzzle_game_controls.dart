import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle_game_controller.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class PuzzleGameControls extends StatefulWidget {
  final PuzzleGameController puzzleController;
  PuzzleGameControls({this.puzzleController});

  @override
  _PuzzleGameControlsState createState() => _PuzzleGameControlsState();
}

class _PuzzleGameControlsState extends State<PuzzleGameControls> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(!widget.puzzleController.running
                ? Icons.play_arrow
                : Icons.pause),
            onPressed: () {
              setState(() {
                widget.puzzleController.running =
                    !widget.puzzleController.running;
              });
            },
          ),
        ),
        Flexible(
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.restore),
            onPressed: () {
              setState(() {
                widget.puzzleController.reset();
              });
            }
          ),
        ),
        Flexible(
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.fast_forward),
            color: widget.puzzleController.speed == GameSpeed.Fast
                ? Colors.green
                : null,
            onPressed: () {
              setState(() {
                widget.puzzleController.speed =
                    widget.puzzleController.speed == GameSpeed.Normal
                        ? GameSpeed.Fast
                        : GameSpeed.Normal;
              });
            },
          ),
        ),
      ],
    );
  }
}
