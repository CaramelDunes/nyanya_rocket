import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle_game_controller.dart';

class PuzzleGameControls extends StatelessWidget {
  final PuzzleGameController puzzleController;

  PuzzleGameControls({required this.puzzleController});

  static final double iconSize = 70.0;

  @override
  Widget build(BuildContext context) {
    bool darkMode = Theme.of(context).brightness == Brightness.dark;

    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      double horizontalPadding = orientation == Orientation.portrait ? 8.0 : 0;
      double verticalPadding = orientation == Orientation.portrait ? 0 : 8.0;

      return ValueListenableBuilder(
        valueListenable: puzzleController.state,
        builder: (context, PuzzleGameState state, _) {
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            direction: orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            children: <Widget>[
              Expanded(
                child: Card(
                  elevation: 8.0,
                  color:
                      puzzleController.madeMistake ? Colors.grey : Colors.green,
                  child: InkWell(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: verticalPadding,
                            horizontal: horizontalPadding),
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
              ),
              Expanded(
                child: Card(
                  elevation: 8.0,
                  color: state.reset ? Colors.grey : Colors.red,
                  child: InkWell(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: verticalPadding,
                            horizontal: horizontalPadding),
                        child: Icon(Icons.replay,
                            size: iconSize, color: Colors.black),
                      ),
                      onTap: state.reset
                          ? null
                          : () {
                              puzzleController.reset();
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
                          vertical: verticalPadding,
                          horizontal: horizontalPadding),
                      child: Icon(
                        Icons.fast_forward,
                        size: iconSize,
                        color: state.spedUp ^ darkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    onTap: () {
                      puzzleController.toggleSpeedUp();
                    },
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
