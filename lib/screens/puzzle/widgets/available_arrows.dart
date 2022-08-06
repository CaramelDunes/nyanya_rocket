import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../widgets/board/tiles/arrow_image.dart';
import '../puzzle_game_controller.dart';
import 'draggable_arrow.dart';

class AvailableArrows extends StatelessWidget {
  final Axis direction;
  final PuzzleGameController puzzleGameController;
  final List<ValueNotifier<int>> draggedArrowCounts;
  final Direction? selectedDirection;
  final Function(Direction direction) onArrowTap;

  const AvailableArrows(
      {super.key,
      required this.direction,
      required this.puzzleGameController,
      required this.draggedArrowCounts,
      required this.onArrowTap,
      this.selectedDirection});

  static Widget _buildArrowAndCount(BuildContext context, Direction direction,
      int count, Brightness brightness, bool canPlace, bool selected) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ArrowImage(
            player: count > 0 && canPlace ? PlayerColor.Blue : null,
            direction: direction,
            isSelected: selected,
          ),
          FractionallySizedBox(
            alignment: Alignment.topRight,
            widthFactor: 0.4,
            heightFactor: 0.4,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(8.0)),
              child: SizedBox.expand(
                child: FittedBox(
                  child: Text(count.toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDraggableArrow(Direction direction,
      ValueNotifier<int> remainingArrows, ValueNotifier<int> draggedCount) {
    final bool selected = direction == selectedDirection;

    return ValueListenableBuilder<int>(
        valueListenable: remainingArrows,
        builder: (BuildContext context, int count, _) {
          final Widget arrowAndCount = ValueListenableBuilder<int>(
              valueListenable: draggedCount,
              builder: (BuildContext context, int offset, _) {
                return AvailableArrows._buildArrowAndCount(
                    context,
                    direction,
                    count - offset,
                    Theme.of(context).brightness,
                    puzzleGameController.canPlaceArrow,
                    selected);
              });

          return GestureDetector(
            onTap: () => onArrowTap(direction),
            child: DraggableArrow(
                player: PlayerColor.Blue,
                data: DraggedArrowData(direction: direction),
                draggedCount: draggedCount,
                maxSimultaneousDrags:
                    puzzleGameController.canPlaceArrow ? count : 0,
                onDragStarted: () => onArrowTap(direction),
                child: arrowAndCount),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: puzzleGameController.state,
      builder: (BuildContext context, PuzzleGameState state, Widget? child) {
        return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            direction: direction,
            children: List.generate(
                4,
                (i) => Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(0.5),
                      child: _buildDraggableArrow(
                          Direction.values[i],
                          puzzleGameController.remainingArrowsStreams[i],
                          draggedArrowCounts[i]),
                    ))));
      },
    );
  }
}
