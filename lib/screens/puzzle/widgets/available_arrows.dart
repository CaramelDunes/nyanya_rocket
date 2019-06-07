import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle_game_controller.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class AvailableArrows extends StatelessWidget {
  final PuzzleGameController puzzleGameController;

  const AvailableArrows({@required this.puzzleGameController});

  Widget _buildDraggableArrow(
      BuildContext context, Orientation orientation, int i) {
    return ValueListenableBuilder<int>(
        valueListenable: puzzleGameController.remainingArrowsStreams[i],
        builder: (BuildContext context, int count, Widget _) {
          return Draggable<Direction>(
              maxSimultaneousDrags:
                  puzzleGameController.canPlaceArrow ? count : 0,
              feedback: const SizedBox.shrink(),
              child: Card(
                child: Flex(
                  direction: orientation == Orientation.portrait
                      ? Axis.horizontal
                      : Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RotatedBox(
                          quarterTurns: -i,
                          child: Image.asset(
                            'assets/graphics/arrow_${count > 0 ? 'blue' : 'grey'}.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      count.toString(),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ],
                ),
              ),
              data: Direction.values[i]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Flex(
            direction: orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            children: List<Widget>.generate(
                4,
                (i) => Expanded(
                    child: _buildDraggableArrow(context, orientation, i))));
      },
    );
  }
}
