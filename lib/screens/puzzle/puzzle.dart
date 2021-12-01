import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/named_puzzle_data.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle_game_controller.dart';
import 'package:nyanya_rocket/screens/puzzle/widgets/available_arrows.dart';
import 'package:nyanya_rocket/screens/puzzle/widgets/puzzle_game_controls.dart';
import 'package:nyanya_rocket/screens/settings/settings.dart';
import 'package:nyanya_rocket/screens/tutorial/tutorial.dart';
import 'package:nyanya_rocket/widgets/arrow_image.dart';
import 'package:nyanya_rocket/widgets/game_view/animated_game_view.dart';
import 'package:nyanya_rocket/widgets/input_grid_overlay.dart';
import 'package:nyanya_rocket/widgets/success_overlay.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

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
  _PuzzleState createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  late PuzzleGameController _puzzleController;
  bool _ended = false;

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

      widget.onWin!(starred);
    }
  }

  Widget _dragTileBuilder(BuildContext context, List<Direction?> candidateData,
      List rejectedData, int x, int y) {
    if (_puzzleController.game.board.tiles[x][y] is Arrow) {
      return Draggable<Direction>(
          maxSimultaneousDrags: 1,
          onDragStarted: () {
            _puzzleController.removeArrow(x, y);
          },
          child: Container(color: Colors.transparent),
          feedback: const SizedBox.shrink(),
          data: (_puzzleController.game.board.tiles[x][y] as Arrow).direction);
    }

    if (candidateData.isEmpty) {
      return const SizedBox.expand();
    }

    return ArrowImage(
      direction: candidateData.first!,
      player: PlayerColor.Blue,
      opaque: false,
    );
  }

  Widget _buildPortrait() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGameView(),
        Flexible(
            child: AvailableArrows(puzzleGameController: _puzzleController)),
        Flexible(
          child: PuzzleGameControls(puzzleController: _puzzleController),
        )
      ],
    );
  }

  Widget _buildLandscape() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: PuzzleGameControls(puzzleController: _puzzleController)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: _buildGameView(),
        ),
        Expanded(
            child: AvailableArrows(puzzleGameController: _puzzleController)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.puzzle.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Settings()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Tutorial()));
            },
          )
        ],
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
    );
  }
}
