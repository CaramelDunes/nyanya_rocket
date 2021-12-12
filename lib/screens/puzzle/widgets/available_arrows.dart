import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../widgets/board/tiles/arrow_image.dart';
import '../puzzle_game_controller.dart';
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
    const double bubbleFactor = 0.33;

    return Stack(
      fit: StackFit.expand,
      children: [
        FractionallySizedBox(
          alignment: Alignment.bottomLeft,
          widthFactor: 1 - bubbleFactor / 4,
          heightFactor: 1 - bubbleFactor / 4,
          child: ArrowImage(
            player: count > 0 && canPlace ? PlayerColor.Blue : null,
            direction: direction,
          ),
        ),
        FractionallySizedBox(
          alignment: Alignment.topRight,
          widthFactor: bubbleFactor,
          heightFactor: bubbleFactor,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: FittedBox(
                child: Text(count.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            direction: direction,
            children: List.generate(
                4,
                (i) => Expanded(
                        child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: _buildDraggableArrow(
                              Direction.values[i],
                              puzzleGameController.remainingArrowsStreams[i],
                              draggedArrowCounts[i]),
                        ),
                      ),
                    ))));
      },
    );
  }
}
