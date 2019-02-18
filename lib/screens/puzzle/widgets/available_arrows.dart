import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle_game_controller.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class AvailableArrows extends StatelessWidget {
  final PuzzleGameController puzzleGameController;

  const AvailableArrows({@required this.puzzleGameController});

  @override
  Widget build(BuildContext context) {
    return Flex(
        direction: MediaQuery.of(context).orientation == Orientation.portrait
            ? Axis.horizontal
            : Axis.vertical,
        children: List<Widget>.generate(
            4,
            (i) => Expanded(
                    child: StreamBuilder<int>(
                  stream: puzzleGameController.remainingArrowsStreams[i].stream,
                  initialData: 0,
                  builder: (BuildContext context,
                          AsyncSnapshot<int> snapshot) =>
                      Draggable<Direction>(
                          maxSimultaneousDrags:
                              puzzleGameController.canPlaceArrow
                                  ? snapshot.data
                                  : 0,
                          feedback: Container(),
                          child: Card(
                            child: Flex(
                              direction: MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? Axis.vertical
                                  : Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: RotatedBox(
                                    quarterTurns: -i,
                                    child: Image(
                                      image: AssetImage(
                                          'assets/graphics/arrow_${snapshot.data > 0 ? 'blue' : 'grey'}.png'),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    "${snapshot.data}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          data: Direction.values[i]),
                ))));
  }
}
