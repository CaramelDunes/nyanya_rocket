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
      double horizontalPadding = orientation == Orientation.portrait ? 8.0 : 0;
      double verticalPadding = orientation == Orientation.portrait ? 0 : 8.0;

      return Flex(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        direction: orientation == Orientation.landscape
            ? Axis.horizontal
            : Axis.vertical,
        children: <Widget>[
          Expanded(
            child: Card(
              elevation: 8.0,
              color: Colors.green,
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: verticalPadding, horizontal: horizontalPadding),
                  child: Icon(
                    !widget.puzzleController.running
                        ? Icons.play_circle_outline
                        : Icons.pause,
                    size: iconSize,
                  ),
                ),
                onTap: () {
                  setState(() {
                    widget.puzzleController.running =
                        !widget.puzzleController.running;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: Card(
              elevation: 8.0,
              color: Colors.red,
              child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: verticalPadding,
                        horizontal: horizontalPadding),
                    child: Icon(Icons.replay, size: iconSize),
                  ),
                  onTap: () {
                    setState(() {
                      widget.puzzleController.reset();
                    });
                  }),
            ),
          ),
          Expanded(
            child: Card(
              elevation: 8.0,
              color: Colors.blue,
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: verticalPadding, horizontal: horizontalPadding),
                  child: Icon(
                    Icons.fast_forward,
                    size: iconSize,
                    color: widget.puzzleController.gameSimulator.speed ==
                            GameSpeed.Fast
                        ? Colors.white
                        : null,
                  ),
                ),
                onTap: () {
                  setState(() {
                    widget.puzzleController.gameSimulator.speed =
                        widget.puzzleController.gameSimulator.speed ==
                                GameSpeed.Normal
                            ? GameSpeed.Fast
                            : GameSpeed.Normal;
                  });
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
