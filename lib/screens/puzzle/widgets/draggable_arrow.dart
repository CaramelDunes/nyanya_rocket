import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../widgets/board/tiles/arrow_image.dart';

class DraggedArrowData {
  final ValueNotifier<bool> isOverBoard;
  final Direction direction;

  DraggedArrowData({required this.direction, bool isOverBoard = false})
      : isOverBoard = ValueNotifier(isOverBoard);
}

class DraggableArrow<T extends DraggedArrowData> extends StatelessWidget {
  final PlayerColor? player;
  final DraggedArrowData data;
  final ValueNotifier<int>? draggedCount;
  final Widget child;
  final int? maxSimultaneousDrags;
  final VoidCallback? onDragStarted;

  const DraggableArrow(
      {Key? key,
      required this.player,
      required this.data,
      required this.child,
      this.draggedCount,
      this.maxSimultaneousDrags,
      this.onDragStarted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<DraggedArrowData>(
        dragAnchorStrategy: childDragAnchorStrategy,
        maxSimultaneousDrags: maxSimultaneousDrags,
        onDragStarted: () {
          draggedCount?.value += 1;
          onDragStarted?.call();
        },
        onDragCompleted: () {
          draggedCount?.value -= 1;
        },
        onDraggableCanceled: (_, __) {
          draggedCount?.value -= 1;
        },
        feedback: ValueListenableBuilder<bool>(
            valueListenable: data.isOverBoard,
            builder: (context, value, _) {
              if (!value) {
                return SizedBox(
                  width: 80,
                  height: 80,
                  child: ArrowImage(
                    player: player,
                    direction: data.direction,
                  ),
                );
              } else {
                return const SizedBox(
                  width: 75,
                  height: 75,
                );
              }
            }),
        data: data,
        child: child);
  }
}
