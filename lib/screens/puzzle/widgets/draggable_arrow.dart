import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../widgets/arrow_image.dart';

class DraggedArrowData {
  final ValueNotifier<bool> isOverBoard;
  final Direction direction;

  DraggedArrowData({required this.direction, bool isOverBoard = false})
      : isOverBoard = ValueNotifier(isOverBoard);
}

class DraggableArrow extends StatelessWidget {
  final DraggedArrowData draggedData;
  final ValueNotifier<int> draggedCount;
  final Widget child;
  final int maxSimultaneousDrags;
  final VoidCallback? onDragStarted;

  const DraggableArrow(
      {Key? key,
      required this.draggedData,
      required this.draggedCount,
      required this.child,
      required this.maxSimultaneousDrags,
      this.onDragStarted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<DraggedArrowData>(
        dragAnchorStrategy: childDragAnchorStrategy,
        maxSimultaneousDrags: maxSimultaneousDrags,
        onDragStarted: () {
          draggedCount.value += 1;
          onDragStarted?.call();
        },
        onDragCompleted: () {
          draggedCount.value -= 1;
        },
        onDraggableCanceled: (_, __) {
          draggedCount.value -= 1;
        },
        feedback: ValueListenableBuilder<bool>(
            valueListenable: draggedData.isOverBoard,
            builder: (context, value, _) {
              if (!value) {
                return SizedBox(
                  width: 75,
                  height: 75,
                  child: ArrowImage(
                    player: PlayerColor.Blue,
                    direction: draggedData.direction,
                  ),
                );
              } else {
                return const SizedBox(
                  width: 75,
                  height: 75,
                );
              }
            }),
        child: child,
        data: draggedData);
  }
}
