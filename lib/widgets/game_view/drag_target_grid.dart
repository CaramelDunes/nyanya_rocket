import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

typedef DropAcceptor<T> = void Function(int x, int y, T t);
typedef TapAcceptor<T> = void Function(int x, int y);
typedef SwipeAcceptor = void Function(int x, int y, Direction direction);
typedef DragTargetTileBuilder<T> = Widget Function(BuildContext context,
    List<T> candidateData, List<dynamic> rejectedData, int x, int y);

class DragTargetGrid<T> extends StatelessWidget {
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

  Widget _dragTargetBuilder(int x, int y) {
    return DragTargetTile<T>(
        x: x,
        y: y,
        builder: tileBuilder,
        dropAcceptor: dropAcceptor,
        swipeAcceptor: swipeAcceptor,
        tapAcceptor: tapAcceptor);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        children: List<Widget>.generate(
            width,
            (x) => Expanded(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: List<Widget>.generate(height,
                          (y) => Expanded(child: _dragTargetBuilder(x, y)))),
                )));
  }
}

class DragTargetTile<T> extends StatelessWidget {
  final int x;
  final int y;
  final DragTargetTileBuilder<T> builder;
  final DropAcceptor<T> dropAcceptor;
  final SwipeAcceptor swipeAcceptor;
  final TapAcceptor<T> tapAcceptor;

  Offset _panOffset = Offset.zero;

  DragTargetTile(
      {@required this.x,
      @required this.y,
      @required this.builder,
      @required this.dropAcceptor,
      this.swipeAcceptor,
      this.tapAcceptor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (tapAcceptor != null) {
            tapAcceptor(x, y);
          }
        },
        onPanStart: (DragStartDetails details) {
          _panOffset = Offset.zero;
        },
        onPanUpdate: (DragUpdateDetails details) {
          _panOffset += details.delta;
        },
        onPanEnd: (DragEndDetails details) {
          if (swipeAcceptor != null) {
            double direction = _panOffset.direction;

            if (-pi / 4 < direction && direction < pi / 4) {
              swipeAcceptor(x, y, Direction.Right);
            } else if (pi / 4 < direction && direction < 3 * pi / 4) {
              swipeAcceptor(x, y, Direction.Down);
            } else if (3 * pi / 4 < direction || direction < -3 * pi / 4) {
              swipeAcceptor(x, y, Direction.Left);
            } else if (-3 * pi / 4 < direction && direction < -pi / 4) {
              swipeAcceptor(x, y, Direction.Up);
            }
          }
        },
        child: DragTarget<T>(
          builder: (BuildContext context, List<T> candidateData,
                  List<dynamic> rejectedData) =>
              builder(context, candidateData, rejectedData, x, y),
          onAccept: (T t) {
            dropAcceptor(x, y, t);
          },
        ));
  }
}
