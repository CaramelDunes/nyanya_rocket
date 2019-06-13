import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/named_puzzle_data.dart';
import 'package:nyanya_rocket/screens/editor/editor_game_controller.dart';
import 'package:nyanya_rocket/screens/editor/menus/standard_menus.dart';
import 'package:nyanya_rocket/screens/editor/widgets/editor_placer.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle.dart';
import 'package:nyanya_rocket/screens/puzzles/widgets/local_puzzles.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class PuzzleEditor extends StatefulWidget {
  final NamedPuzzleData puzzle;
  final String uuid;

  PuzzleEditor({
    @required this.puzzle,
    this.uuid,
  });

  @override
  _PuzzleEditorState createState() {
    return _PuzzleEditorState();
  }
}

class _PuzzleEditorState extends State<PuzzleEditor> {
  EditorGameController _editorGameController;
  String _uuid;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _editorGameController =
        EditorGameController(game: widget.puzzle.puzzleData.getGame());

    for (int direction = 0; direction < 4; direction++) {
      _initExistingArrows(Direction.values[direction],
          widget.puzzle.puzzleData.availableArrows[direction]);
    }

    _uuid = widget.uuid;
  }

  @override
  void dispose() {
    super.dispose();

    _editorGameController.close();
  }

  void _initExistingArrows(Direction direction, int count) {
    if (count <= 0) {
      return;
    }

    for (int x = 0; x < Board.width; x++) {
      for (int y = 0; y < Board.height; y++) {
        if (_editorGameController.game.board.tiles[x][y] is Empty) {
          _editorGameController.toggleTile(
              x, y, Arrow(direction: direction, player: PlayerColor.Blue));

          if (--count == 0) {
            return;
          }
        }
      }
    }
  }

  NamedPuzzleData _buildPuzzleData() {
    List<int> availableArrows = List.filled(4, 0);

    Board copy = Board.copy(_editorGameController.game.board);

    for (int x = 0; x < Board.width; x++) {
      for (int y = 0; y < Board.height; y++) {
        if (copy.tiles[x][y] is Arrow) {
          Arrow arrow = copy.tiles[x][y] as Arrow;
          availableArrows[arrow.direction.index]++;
          copy.tiles[x][y] = Empty();
        }
      }
    }

    dynamic gameJson = _editorGameController.game.toJson(); // TODO Cleaner way
    gameJson['board'] = copy.toJson();

    return NamedPuzzleData(
        name: widget.puzzle.name,
        gameData: jsonEncode(gameJson),
        availableArrows: availableArrows);
  }

  void _handlePlay(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => Puzzle(
              hasNext: false,
              puzzle: _buildPuzzleData(),
            )));
  }

  void _handleSave() {
    // Avoid creating 2 puzzles.
    // A better solution would be to move the effective puzzle creation to the
    // editor create tab.
    if (_saving) {
      return;
    }

    _saving = true;

    if (_uuid == null) {
      LocalPuzzles.store.saveNewPuzzle(_buildPuzzleData()).then((String uuid) {
        this._uuid = uuid;
        print('Saved $uuid');
        _saving = false;
      });
    } else {
      LocalPuzzles.store
          .updatePuzzle(_uuid, _buildPuzzleData().puzzleData)
          .then((bool status) {
        print('Updated $_uuid');
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.puzzle.name),
      ),
      resizeToAvoidBottomPadding: false,
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return Flex(
            direction: orientation == Orientation.portrait
                ? Axis.vertical
                : Axis.horizontal,
            children: <Widget>[
              Expanded(
                  child: EditorPlacer(
                      editorGameController: _editorGameController,
                      onPlay: () => _handlePlay(context),
                      onSave: _handleSave,
                      menus: [
                    EditorMenu(subMenu: <EditorTool>[
                      EditorTool(
                          type: ToolType.Tile,
                          tile: Rocket(player: PlayerColor.Blue)),
                      EditorTool(type: ToolType.Tile, tile: Pit())
                    ]),
                    StandardMenus.arrows,
                    StandardMenus.mice,
                    StandardMenus.cats,
                    StandardMenus.walls,
                  ])),
            ],
          );
        },
      ),
    );
  }
}
