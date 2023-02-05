import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../board/tiles/arrow_image.dart';
import '../../screens/puzzle/widgets/draggable_arrow.dart';

class ArrowDrawer extends StatelessWidget {
  final Axis layoutDirection;
  final PlayerColor? player;
  final bool running;
  final Direction? selectedDirection;
  final Function(Direction) onTap;

  const ArrowDrawer(
      {super.key,
      required this.layoutDirection,
      required this.player,
      required this.running,
      required this.selectedDirection,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Flex(
        direction: layoutDirection,
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
            isSelected: direction == selectedDirection,
          )),
    );
  }
}
