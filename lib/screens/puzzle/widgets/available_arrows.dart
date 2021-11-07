import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle_game_controller.dart';
import 'package:nyanya_rocket/widgets/arrow_image.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class AvailableArrows extends StatelessWidget {
  final PuzzleGameController puzzleGameController;

  const AvailableArrows({Key? key, required this.puzzleGameController})
      : super(key: key);

  static Widget _buildArrowAndCount(
      int i, int count, Brightness brightness, bool canPlace) {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        ArrowImage(
          player: count > 0 && canPlace ? PlayerColor.Blue : null,
          direction: Direction.values[i],
        ),
        if (count > 0)
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                color:
                    brightness == Brightness.dark ? Colors.black : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                child: Text(
                  count.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
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
        builder: (BuildContext context, int count, _) {
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
          builder:
              (BuildContext context, PuzzleGameState state, Widget? child) {
            return Flex(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                direction: orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: List<Widget>.generate(
                    4,
                    (i) => Flexible(
                            child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: _buildDraggableArrow(context, orientation, i),
                        ))));
          },
        );
      },
    );
  }
}
