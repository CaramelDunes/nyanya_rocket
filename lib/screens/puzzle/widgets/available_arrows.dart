import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle_game_controller.dart';
import 'package:nyanya_rocket/widgets/arrow_image.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import 'draggable_arrow.dart';

class AvailableArrows extends StatelessWidget {
  final Axis direction;
  final PuzzleGameController puzzleGameController;
  final List<ValueNotifier<int>> draggedArrowCounts;

  const AvailableArrows(
      {Key? key,
      required this.direction,
      required this.puzzleGameController,
      required this.draggedArrowCounts})
      : super(key: key);

  static Widget _buildArrowAndCount(
      Direction direction, int count, Brightness brightness, bool canPlace) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: ArrowImage(
            player: count > 0 && canPlace ? PlayerColor.Blue : null,
            direction: direction,
          ),
        ),
        if (count > 0)
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
              child: Text(
                count.toString(),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
            ),
          )
      ],
    );
  }

  Widget _buildDraggableArrow(Direction direction,
      ValueNotifier<int> remainingArrows, ValueNotifier<int> draggedCount) {
    return ValueListenableBuilder<int>(
        valueListenable: remainingArrows,
        builder: (BuildContext context, int count, _) {
          final Widget arrowAndCount = ValueListenableBuilder<int>(
              valueListenable: draggedCount,
              builder: (BuildContext context, int offset, _) {
                return AvailableArrows._buildArrowAndCount(
                    direction,
                    count - offset,
                    Theme.of(context).brightness,
                    puzzleGameController.canPlaceArrow);
              });

          return DraggableArrow(
              data: DraggedArrowData(direction: direction),
              draggedCount: draggedCount,
              child: arrowAndCount,
              maxSimultaneousDrags:
                  puzzleGameController.canPlaceArrow ? count : 0);
        });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: puzzleGameController.state,
      builder: (BuildContext context, PuzzleGameState state, Widget? child) {
        return Flex(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            direction: direction,
            children: List.generate(
                4,
                (i) => Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: _buildDraggableArrow(
                          Direction.values[i],
                          puzzleGameController.remainingArrowsStreams[i],
                          draggedArrowCounts[i]),
                    ))));
      },
    );
  }
}
