import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle_game_controller.dart';

class PuzzleGameControls extends StatelessWidget {
  final Axis direction;
  final PuzzleGameController puzzleController;

  const PuzzleGameControls(
      {Key? key, required this.direction, required this.puzzleController})
      : super(key: key);

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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.black,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Icon(
                        !state.running
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                        size: iconSize),
                  ),
                  onPressed: !puzzleController.madeMistake
                      ? () {
                          puzzleController.running = !puzzleController.running;
                        }
                      : null,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.black,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Icon(Icons.replay, size: iconSize),
                  ),
                  onPressed: state.reset
                      ? null
                      : () {
                          puzzleController.reset();
                        },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: FaIcon(
                      Icons.fast_forward_rounded,
                      size: iconSize,
                      color: state.spedUp ? Colors.white : Colors.black,
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
