import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../widgets/arrow_image.dart';
import '../../puzzle/widgets/draggable_arrow.dart';

class ArrowDrawer extends StatelessWidget {
  final bool running;

  const ArrowDrawer({Key? key, required this.running}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
        direction: MediaQuery.of(context).orientation == Orientation.landscape
            ? Axis.vertical
            : Axis.horizontal,
        children: List<Widget>.generate(
            4,
            (i) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: DraggableArrow(
                        maxSimultaneousDrags: running ? 1 : 0,
                        data: DraggedArrowData(direction: Direction.values[i]),
                        child: ArrowImage(
                            player: running ? PlayerColor.Blue : null,
                            direction: Direction.values[i])),
                  ),
                )));
  }
}
