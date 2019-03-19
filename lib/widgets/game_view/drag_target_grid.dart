import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

typedef DropAcceptor<T> = void Function(int x, int y, T t);
typedef TapAcceptor<T> = void Function(int x, int y);
typedef SwipeAcceptor = void Function(int x, int y, Direction direction);
typedef DragTargetTileBuilder<T> = Widget Function(BuildContext context,
    List<T> candidateData, List<dynamic> rejectedData, int x, int y);

class DragTargetGrid<T> extends StatefulWidget {
  final int width;
  final int height;
  final DragTargetTileBuilder<T> tileBuilder;
  final DropAcceptor<T> dropAcceptor;
  final TapAcceptor<T> tapAcceptor;
  final SwipeAcceptor swipeAcceptor;

  const DragTargetGrid(
      {Key key,
      @required this.width,
      @required this.height,
      @required this.tileBuilder,
      @required this.dropAcceptor,
      this.tapAcceptor,
      this.swipeAcceptor})
      : super(key: key);

  @override
  _DragTargetGridState<T> createState() {
    return _DragTargetGridState();
  }
}

class _DragTargetGridState<T> extends State<DragTargetGrid<T>> {
  PointerDownEvent _downEvent;

  Widget _dragTargetBuilder(int x, int y) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (PointerDownEvent event) => _downEvent = event,
      onPointerUp: (PointerUpEvent event) {
        Offset difference = event.position - _downEvent.position;

        double direction = difference.direction;

        if (widget.tapAcceptor != null && difference.distanceSquared < 10) {
          widget.tapAcceptor(x, y);
        } else if (widget.swipeAcceptor != null &&
            difference.distanceSquared > 30) {
          if (-pi / 4 < direction && direction < pi / 4) {
            widget.swipeAcceptor(x, y, Direction.Right);
          } else if (pi / 4 < direction && direction < 3 * pi / 4) {
            widget.swipeAcceptor(x, y, Direction.Down);
          } else if (3 * pi / 4 < direction || direction < -3 * pi / 4) {
            widget.swipeAcceptor(x, y, Direction.Left);
          } else if (-3 * pi / 4 < direction && direction < -pi / 4) {
            widget.swipeAcceptor(x, y, Direction.Up);
          }
        }
      },
      child: widget.tileBuilder != null
          ? DragTargetTile<T>(
              x: x,
              y: y,
              builder: widget.tileBuilder,
              acceptor: widget.dropAcceptor,
            )
          : Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List<Widget>.generate(
            widget.width,
            (x) => Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List<Widget>.generate(widget.height,
                          (y) => Expanded(child: _dragTargetBuilder(x, y)))),
                )));
  }
}

class DragTargetTile<T> extends StatelessWidget {
  final int x;
  final int y;
  final DragTargetTileBuilder<T> builder;
  final DropAcceptor<T> acceptor;

  const DragTargetTile(
      {@required this.x,
      @required this.y,
      @required this.builder,
      @required this.acceptor});

  @override
  Widget build(BuildContext context) {
    return DragTarget<T>(
      builder: (BuildContext context, List<T> candidateData,
              List<dynamic> rejectedData) =>
          builder(context, candidateData, rejectedData, x, y),
      onAccept: (T t) {
        acceptor(x, y, t);
      },
    );
  }
}
