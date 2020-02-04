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
              child: IntrinsicHeight(
                child: Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    RotatedBox(
                      quarterTurns: -i,
                      child: Image.asset(
                        'assets/graphics/arrow_${count > 0 ? 'blue' : 'grey'}.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              count.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                    )
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            direction: orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            children: List<Widget>.generate(
                4,
                (i) => Flexible(
                    child: _buildDraggableArrow(context, orientation, i))));
      },
    );
  }
}
