import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle_game_controller.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class AvailableArrows extends StatelessWidget {
  final PuzzleGameController puzzleGameController;

  const AvailableArrows({@required this.puzzleGameController});

  static Widget _buildArrowAndCount(
      int i, int count, Brightness brightness, bool canPlace) {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        Material(
          elevation: 8,
          child: RotatedBox(
            quarterTurns: -i,
            child: Image.asset(
              'assets/graphics/arrow_${count > 0 && canPlace ? 'blue' : 'grey'}.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            decoration: BoxDecoration(
              color:
                  brightness == Brightness.dark ? Colors.black : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Text(
                count.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDraggableArrow(
      BuildContext context, Orientation orientation, int i) {
    return ValueListenableBuilder<int>(
        valueListenable: puzzleGameController.remainingArrowsStreams[i],
        builder: (BuildContext context, int count, Widget _) {
          final Widget arrowAndCount = _buildArrowAndCount(i, count,
              Theme.of(context).brightness, puzzleGameController.canPlaceArrow);

          final Widget intrinsicChild = orientation == Orientation.landscape
              ? IntrinsicHeight(child: arrowAndCount)
              : IntrinsicWidth(child: arrowAndCount);

          return Draggable<Direction>(
              maxSimultaneousDrags:
                  puzzleGameController.canPlaceArrow ? count : 0,
              feedback: const SizedBox.shrink(),
              child: intrinsicChild,
              data: Direction.values[i]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return ValueListenableBuilder(
          valueListenable: puzzleGameController.state,
          builder: (context, state, _) {
            return Flex(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                direction: orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: List<Widget>.generate(
                    4,
                    (i) => Flexible(
                            child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: _buildDraggableArrow(context, orientation, i),
                        ))));
          },
        );
      },
    );
  }
}
