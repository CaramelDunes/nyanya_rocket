import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle_game_controller.dart';

class PuzzleGameControls extends StatelessWidget {
  final Axis direction;
  final PuzzleGameController puzzleController;

  const PuzzleGameControls(
      {super.key, required this.direction, required this.puzzleController});

  static const double iconSize = 50.0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: puzzleController.state,
      builder: (context, PuzzleGameState state, Widget? child) {
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          direction: direction,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black),
                  onPressed: !puzzleController.hasMadeMistake
                      ? () {
                          puzzleController.running = !puzzleController.running;
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Icon(
                        !state.isRunning
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                        size: iconSize),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.black),
                  onPressed: state.hasReset
                      ? null
                      : () {
                          puzzleController.reset();
                        },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Icon(Icons.replay, size: iconSize),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: FaIcon(
                      Icons.fast_forward_rounded,
                      size: iconSize,
                      color: state.isSpedUp ? Colors.white : Colors.black,
                    ),
                  ),
                  onPressed: () {
                    puzzleController.toggleSpeedUp();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
