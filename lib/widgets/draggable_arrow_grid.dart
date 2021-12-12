import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../screens/puzzle/widgets/draggable_arrow.dart';
import 'game_view/drag_target_grid.dart';

class DraggableArrowGrid<T extends DraggedArrowData> extends StatelessWidget {
  final Widget child;

  final DropAcceptor<T> onDrop;
  final SwipeAcceptor? onSwipe;
  final TapAcceptor? onTap;
  final DragTargetTileBuilder<T> previewBuilder;
  final OnWillAccept<Direction>? onWillAccept;

  const DraggableArrowGrid({
    Key? key,
    required this.child,
    required this.onDrop,
    required this.previewBuilder,
    this.onSwipe,
    this.onTap,
    this.onWillAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      child,
      DragTargetGrid<T>(
        width: Board.width,
        height: Board.height,
        tileBuilder: previewBuilder,
        dropAcceptor: _handleDrop,
        tapAcceptor: onTap,
        swipeAcceptor: onSwipe,
        onWillAccept: _handleOnWillAccept,
        onLeave: _handleOnLeave,
      )
    ]);
  }

  void _handleDrop(int x, int y, T draggedArrow) {
    draggedArrow.isOverBoard.value = false;

    onDrop(x, y, draggedArrow);
  }

  void _handleOnLeave(int x, int y, T? draggedArrow) {
    if (draggedArrow != null) {
      draggedArrow.isOverBoard.value = false;
    }
  }

  bool _handleOnWillAccept(int x, int y, T? draggedArrow) {
    if (draggedArrow != null) {
      draggedArrow.isOverBoard.value = true;
    }

    return onWillAccept == null || onWillAccept!(x, y, draggedArrow?.direction);
  }
}
