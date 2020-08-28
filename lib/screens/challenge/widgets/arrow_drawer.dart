import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/arrow_image.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class ArrowDrawer extends StatelessWidget {
  final bool running;

  const ArrowDrawer({Key key, @required this.running}) : super(key: key);

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
                    padding: const EdgeInsets.all(2.0),
                    child: Draggable<Direction>(
                        maxSimultaneousDrags: running ? null : 0,
                        feedback: const SizedBox.shrink(),
                        child: Material(
                          elevation: 8.0,
                          child: running
                              ? ArrowImage(
                                  player: PlayerColor.Blue,
                                  direction: Direction.values[i])
                              : RotatedBox(
                                  quarterTurns: -i,
                                  child: Image.asset(
                                    'assets/graphics/arrow_grey.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                        ),
                        data: Direction.values[i]),
                  ),
                )));
  }
}
