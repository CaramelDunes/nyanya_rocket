import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../widgets/board/tiles/arrow_image.dart';
import '../../puzzle/widgets/draggable_arrow.dart';

class ArrowDrawer extends StatelessWidget {
  final PlayerColor? player;
  final bool running;
  final Direction? selectedDirection;
  final Function(Direction) onTap;

  const ArrowDrawer(
      {Key? key,
      required this.player,
      required this.running,
      required this.selectedDirection,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
        direction: MediaQuery.of(context).orientation == Orientation.landscape
            ? Axis.vertical
            : Axis.horizontal,
        children: Direction.values
            .map((direction) => Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: _buildDraggableArrow(direction)),
                ))
            .toList());
  }

  Widget _buildDraggableArrow(Direction direction) {
    return GestureDetector(
      onTap: () => onTap(direction),
      child: DraggableArrow(
          player: player,
          maxSimultaneousDrags: running ? 1 : 0,
          data: DraggedArrowData(direction: direction),
          child: ArrowImage(
            player: running ? player : null,
            direction: direction,
            selected: direction == selectedDirection,
          )),
    );
  }
}
