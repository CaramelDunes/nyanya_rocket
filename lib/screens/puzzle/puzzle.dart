import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/navigation/guide_action.dart';
import 'package:nyanya_rocket/widgets/navigation/settings_action.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../models/named_puzzle_data.dart';
import '../../routing/nyanya_route_path.dart';
import '../../widgets/input/draggable_arrow_grid.dart';
import '../../widgets/board/animated_game_view.dart';
import '../../widgets/board/tiles/arrow_image.dart';
import '../../widgets/game/success_overlay.dart';
import 'puzzle_game_controller.dart';
import 'widgets/available_arrows.dart';
import 'widgets/draggable_arrow.dart';
import 'widgets/puzzle_game_controls.dart';

class Puzzle extends StatefulWidget {
  final NamedPuzzleData puzzle;
  final void Function(bool starred)? onWin;
  final String? documentPath;
  final NyaNyaRoutePath? nextRoutePath;

  const Puzzle(
      {Key? key,
      required this.puzzle,
      this.nextRoutePath,
      this.onWin,
      this.documentPath})
      : super(key: key);

  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  late PuzzleGameController _puzzleController;
  bool _ended = false;
  final List<ValueNotifier<int>> _draggedArrowCount =
      List.generate(4, (_) => ValueNotifier(0), growable: false);
  Direction? selectedDirection;

  @override
  void initState() {
    super.initState();

    _puzzleController =
        PuzzleGameController(puzzle: widget.puzzle.data, onWin: _handleWin);
  }

  @override
  void dispose() {
    _puzzleController.dispose();

    super.dispose();
  }

  void _handleTap(int x, int y) {
    if (_puzzleController.hasArrow(x, y)) {
      _puzzleController.removeArrow(x, y);
    } else if (selectedDirection != null) {
      _puzzleController.placeArrow(x, y, selectedDirection!);
    }
  }

  void _handleDrop(int x, int y, DraggedArrowData arrow) {
    _puzzleController.placeArrow(x, y, arrow.direction);
  }

  void _handleSwipe(int x, int y, Direction direction) {
    _puzzleController.placeArrow(x, y, direction);
  }

  void _handleArrowTap(Direction direction) {
    if (selectedDirection == direction) {
      return;
    }

    setState(() {
      selectedDirection = direction;
    });
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

      widget.onWin!(starred);
    }
  }

  Widget _dragTileBuilder(BuildContext context,
      List<DraggedArrowData?> candidateData, List rejectedData, int x, int y) {
    if (_puzzleController.game.board.tiles[x][y] is Arrow) {
      final Direction arrowDirection =
          (_puzzleController.game.board.tiles[x][y] as Arrow).direction;
      return ValueListenableBuilder<PuzzleGameState>(
          valueListenable: _puzzleController.state,
          builder: (context, value, __) {
            return DraggableArrow(
              maxSimultaneousDrags: value.reset ? 1 : 0,
              data: DraggedArrowData(
                  direction: arrowDirection, isOverBoard: true),
              draggedCount: _draggedArrowCount[arrowDirection.index],
              child: Container(color: Colors.transparent),
              onDragStarted: () {
                _puzzleController.removeArrow(x, y);
              },
            );
          });
    }

    if (candidateData.isEmpty) {
      return const SizedBox.expand();
    }

    return ArrowImage(
      direction: candidateData.first!.direction,
      player: PlayerColor.Blue,
      isHalfTransparent: true,
    );
  }

  Widget _buildPortrait() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: _buildGameView(),
        ),
        Flexible(
            child: AvailableArrows(
          direction: Axis.horizontal,
          puzzleGameController: _puzzleController,
          draggedArrowCounts: _draggedArrowCount,
          onArrowTap: _handleArrowTap,
          selectedDirection: selectedDirection,
        )),
        Flexible(
          child: PuzzleGameControls(
            direction: Axis.horizontal,
            puzzleController: _puzzleController,
          ),
        )
      ],
    );
  }

  Widget _buildLandscape() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: PuzzleGameControls(
          direction: Axis.vertical,
          puzzleController: _puzzleController,
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildGameView(),
        ),
        Expanded(
            child: AvailableArrows(
          direction: Axis.vertical,
          puzzleGameController: _puzzleController,
          draggedArrowCounts: _draggedArrowCount,
          selectedDirection: selectedDirection,
          onArrowTap: _handleArrowTap,
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.puzzle.name),
        actions: const [SettingsAction(), GuideAction()],
      ),
      body: Stack(
        fit: StackFit.passthrough,
        children: [
          OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              if (orientation == Orientation.portrait) {
                return _buildPortrait();
              } else {
                return _buildLandscape();
              }
            },
          ),
          Visibility(
              visible: _ended,
              child: SuccessOverlay(
                nextRoutePath: widget.nextRoutePath,
                succeededPath: widget.documentPath,
                onPlayAgain: () {
                  _puzzleController.reset();
                  _puzzleController.removeAllArrows();
                  setState(() {
                    _ended = false;
                  });
                },
              )),
        ],
      ),
    );
  }

  Widget _buildGameView() {
    return Material(
      elevation: 8.0,
      child: AspectRatio(
          aspectRatio: 12.0 / 9.0,
          child: DraggableArrowGrid<DraggedArrowData>(
            onDrop: _handleDrop,
            onSwipe: _handleSwipe,
            onTap: _handleTap,
            previewBuilder: _dragTileBuilder,
            onWillAccept: _handleOnWillAccept,
            child: AnimatedGameView(
              game: _puzzleController.gameStream,
              mistake: _puzzleController.mistake,
            ),
          )),
    );
  }

  bool _handleOnWillAccept(int x, int y, Direction? draggedArrow) {
    return _puzzleController.game.board.tiles[x][y] is Empty ||
        _puzzleController.game.board.tiles[x][y] is Arrow;
  }
}
