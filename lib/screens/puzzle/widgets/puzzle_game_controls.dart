import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle_game_controller.dart';

class PuzzleGameControls extends StatelessWidget {
  final PuzzleGameController puzzleController;

  const PuzzleGameControls({Key? key, required this.puzzleController})
      : super(key: key);

  static const double iconSize = 50.0;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      return ValueListenableBuilder(
        valueListenable: puzzleController.state,
        builder: (context, PuzzleGameState state, Widget? child) {
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            direction: orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            children: <Widget>[
              Card(
                elevation: 8.0,
                color:
                    puzzleController.madeMistake ? Colors.grey : Colors.green,
                child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                          !state.running
                              ? Icons.play_circle_outline
                              : Icons.pause,
                          size: iconSize,
                          color: Colors.black),
                    ),
                    onTap: !puzzleController.madeMistake
                        ? () {
                            puzzleController.running =
                                !puzzleController.running;
                          }
                        : null),
              ),
              Card(
                elevation: 8.0,
                color: state.reset ? Colors.grey : Colors.red,
                child: InkWell(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.replay,
                          size: iconSize, color: Colors.black),
                    ),
                    onTap: state.reset
                        ? null
                        : () {
                            puzzleController.reset();
                          }),
              ),
              Card(
                elevation: 8.0,
                color: Colors.blue,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.fast_forward,
                      size: iconSize,
                      color: state.spedUp ? Colors.white : Colors.black,
                    ),
                  ),
                  onTap: () {
                    puzzleController.toggleSpeedUp();
                  },
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
