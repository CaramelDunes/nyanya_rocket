import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/drag_target_grid.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class InputGridOverlay<T> extends StatelessWidget {
  final Widget child;

  final DropAcceptor<T> onDrop;
  final TapAcceptor<T> onTap;
  final SwipeAcceptor onSwipe;
  final DragTargetTileBuilder<T> previewBuilder;

  const InputGridOverlay(
      {@required this.child,
      this.onDrop,
      this.onTap,
      this.onSwipe,
      this.previewBuilder});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      child,
      DragTargetGrid<T>(
        width: Board.width,
        height: Board.height,
        tileBuilder: previewBuilder,
        dropAcceptor: onDrop,
        tapAcceptor: onTap,
        swipeAcceptor: onSwipe,
      )
    ]);
  }
}
