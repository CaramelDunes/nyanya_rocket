import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/named_puzzle_data.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle_game_controller.dart';
import 'package:nyanya_rocket/screens/puzzle/widgets/available_arrows.dart';
import 'package:nyanya_rocket/screens/puzzle/widgets/puzzle_game_controls.dart';
import 'package:nyanya_rocket/widgets/arrow_image.dart';
import 'package:nyanya_rocket/widgets/game_view/animated_game_view.dart';
import 'package:nyanya_rocket/widgets/input_grid_overlay.dart';
import 'package:nyanya_rocket/widgets/success_overlay.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class Puzzle extends StatefulWidget {
  final NamedPuzzleData puzzle;
  final void Function(bool starred) onWin;
  final String documentPath;
  final bool hasNext;

  Puzzle(
      {@required this.puzzle,
      @required this.hasNext,
      this.onWin,
      this.documentPath});

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

    _puzzleController = PuzzleGameController(
        puzzle: widget.puzzle.puzzleData, onWin: _handleWin);
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
    if (_puzzleController.game.board.tiles[x][y] is Arrow) {
      return Draggable<Direction>(
          maxSimultaneousDrags: 1,
          onDragStarted: () {
            _puzzleController.removeArrow(x, y);
          },
          child: Container(color: Colors.transparent),
          feedback: SizedBox.shrink(),
          data: (_puzzleController.game.board.tiles[x][y] as Arrow).direction);
    }

    if (candidateData.length == 0) return const SizedBox.expand();

    return ArrowImage(
      direction: candidateData[0],
      player: PlayerColor.Blue,
      opaque: false,
    );
  }

  Widget _buildPortrait(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
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
          ],
        ),
        Flexible(flex: 1, child: _availableArrows),
        Flexible(
          child: PuzzleGameControls(
            puzzleController: _puzzleController,
          ),
        ),
      ],
    );
  }

  Widget _buildLandscape(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
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
            PuzzleGameControls(
              puzzleController: _puzzleController,
            ),
          ],
        ),
        Flexible(flex: 1, child: _availableArrows),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.puzzle.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/tutorial');
            },
          )
        ],
      ),
      body: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              if (orientation == Orientation.portrait) {
                return _buildPortrait(context);
              } else {
                return _buildLandscape(context);
              }
            },
          ),
          Visibility(
              visible: _ended,
              child: SuccessOverlay(
                hasNext: widget.hasNext,
                succeededName: widget.puzzle.name,
                succeededPath: widget.documentPath,
              )),
        ],
      ),
    );
  }
}
