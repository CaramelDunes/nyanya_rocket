import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:nyanya_rocket/widgets/arrow_image.dart';
import 'package:nyanya_rocket/widgets/input_grid_overlay.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle_game_controller.dart';
import 'package:nyanya_rocket/screens/puzzle/widgets/available_arrows.dart';
import 'package:nyanya_rocket/screens/puzzle/widgets/puzzle_game_controls.dart';
import 'package:nyanya_rocket/widgets/game_view/animated_game_view.dart';
import 'package:nyanya_rocket/widgets/success_overlay.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class PuzzlePopData {
  final bool playNext;

  PuzzlePopData({@required this.playNext});
}

class Puzzle extends StatefulWidget {
  final PuzzleData puzzle;
  final void Function(bool starred) onWin;
  final void Function() playNext;

  Puzzle({this.puzzle, this.onWin, this.playNext});

  @override
  _PuzzleState createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  PuzzleGameController _puzzleController;
  AvailableArrows _availableArrows;
  bool _ended = false;

  @override
  void initState() {
    super.initState();

    _puzzleController =
        PuzzleGameController(puzzle: widget.puzzle, onWin: _handleWin);
    _availableArrows = AvailableArrows(
      puzzleGameController: _puzzleController,
    );
  }

  @override
  void dispose() {
    super.dispose();

    _puzzleController.close();
  }

  void _handleTap(int x, int y) {
    _puzzleController.removeArrow(x, y);
  }

  void _handleDropAndSwipe(int x, int y, Direction direction) {
    _puzzleController.placeArrow(x, y, direction);
  }

  void _handleWin() {
    setState(() {
      _ended = true;
    });

    if (widget.onWin != null) {
      bool starred = _puzzleController.remainingArrows(Direction.Right) > 0 ||
          _puzzleController.remainingArrows(Direction.Up) > 0 ||
          _puzzleController.remainingArrows(Direction.Left) > 0 ||
          _puzzleController.remainingArrows(Direction.Down) > 0;

      widget.onWin(starred);
    }
  }

  Widget _dragTileBuilder(BuildContext context, List<Direction> candidateData,
      List rejectedData, int x, int y) {
    if (candidateData.length == 0) return const SizedBox.expand();

    return ArrowImage(
      direction: candidateData[0],
      player: PlayerColor.Blue,
      opaque: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.puzzle.name),
      ),
      body: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              return Flex(
                direction: orientation == Orientation.portrait
                    ? Axis.vertical
                    : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: orientation == Orientation.portrait
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AspectRatio(
                              aspectRatio: 12.0 / 9.0,
                              child: InputGridOverlay<Direction>(
                                child: AnimatedGameView(
                                  game: _puzzleController.gameStream,
                                  mistake: _puzzleController.mistake,
                                ),
                                onDrop: _handleDropAndSwipe,
                                onTap: _handleTap,
                                onSwipe: _handleDropAndSwipe,
                                previewBuilder: _dragTileBuilder,
                              )),
                        ),
                      ),
                      Visibility(
                        visible: orientation == Orientation.landscape,
                        child: PuzzleGameControls(
                          puzzleController: _puzzleController,
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: _availableArrows),
                  Visibility(
                    visible: orientation == Orientation.portrait,
                    child: Flexible(
                      child: PuzzleGameControls(
                        puzzleController: _puzzleController,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Visibility(
              visible: _ended,
              child: SuccessOverlay(succeededName: widget.puzzle.name)),
        ],
      ),
    );
  }
}
