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
  static final double iconSize = 70.0;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      return Flex(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        direction: orientation == Orientation.landscape
            ? Axis.horizontal
            : Axis.vertical,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: new BoxDecoration(
                    color: Colors.green,
                    borderRadius: new BorderRadius.all(Radius.circular(8.0))),
                child: IconButton(
                  iconSize: iconSize,
                  icon: Icon(!widget.puzzleController.running
                      ? Icons.play_circle_outline
                      : Icons.pause),
                  onPressed: () {
                    setState(() {
                      widget.puzzleController.running =
                          !widget.puzzleController.running;
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: new BorderRadius.all(Radius.circular(8.0))),
                child: IconButton(
                    iconSize: iconSize,
                    icon: Icon(Icons.replay),
                    onPressed: () {
                      setState(() {
                        widget.puzzleController.reset();
                      });
                    }),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: new BoxDecoration(
                    color: Colors.blue,
                    borderRadius: new BorderRadius.all(Radius.circular(8.0))),
                child: IconButton(
                  iconSize: iconSize,
                  icon: Icon(Icons.fast_forward),
                  color: widget.puzzleController.speed == GameSpeed.Fast
                      ? Colors.white
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
            ),
          ),
        ],
      );
    });
  }
}
