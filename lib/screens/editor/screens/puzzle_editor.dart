import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/named_puzzle_data.dart';
import 'package:nyanya_rocket/screens/editor/edited_game.dart';
import 'package:nyanya_rocket/screens/editor/menus/standard_menus.dart';
import 'package:nyanya_rocket/screens/editor/widgets/editor_placer.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../models/stores/puzzle_store.dart';

class PuzzleEditor extends StatefulWidget {
  final NamedPuzzleData puzzle;
  final String? uuid;

  const PuzzleEditor({
    super.key,
    required this.puzzle,
    this.uuid,
  });

  @override
  State<PuzzleEditor> createState() => _PuzzleEditorState();
}

class _PuzzleEditorState extends State<PuzzleEditor> {
  late EditedGame _editedGame;
  String? _uuid;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _editedGame = EditedGame(game: widget.puzzle.data.getGame());

    for (int direction = 0; direction < 4; direction++) {
      _initExistingArrows(Direction.values[direction],
          widget.puzzle.data.availableArrows[direction]);
    }

    _uuid = widget.uuid;
  }

  @override
  void dispose() {
    super.dispose();

    _editedGame.dispose();
  }

  void _initExistingArrows(Direction direction, int count) {
    if (count <= 0) {
      return;
    }

    for (int x = 0; x < Board.width; x++) {
      for (int y = 0; y < Board.height; y++) {
        if (_editedGame.game.board.tiles[x][y] is Empty) {
          _editedGame.toggleTile(
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

    Board copy = Board.copy(_editedGame.game.board);

    for (int x = 0; x < Board.width; x++) {
      for (int y = 0; y < Board.height; y++) {
        if (copy.tiles[x][y] is Arrow) {
          Arrow arrow = copy.tiles[x][y] as Arrow;
          availableArrows[arrow.direction.index]++;
          copy.tiles[x][y] = const Empty();
        }
      }
    }

    dynamic gameJson = _editedGame.game.toJson(); // TODO Cleaner way
    gameJson['board'] = copy.toJson();

    return NamedPuzzleData.fromGameData(
        name: widget.puzzle.name,
        gameData: jsonEncode(gameJson),
        availableArrows: availableArrows);
  }

  void _handlePlay(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext _) => Puzzle(
              puzzle: _buildPuzzleData(),
            )));
  }

  void _handleSave() {
    // Avoid creating 2 puzzles.
    // A better solution would be to move the effective puzzle creation to the
    // editor create tab.
    if (_isSaving) {
      return;
    }

    _isSaving = true;

    if (_uuid == null) {
      PuzzleStore.saveNew(_buildPuzzleData()).then((String? uuid) {
        if (uuid != null) {
          _uuid = uuid;
          print('Saved $uuid');
          _isSaving = false;
        } // TODO Handle failure.
      });
    } else {
      PuzzleStore.update(_uuid!, _buildPuzzleData().data).then((bool status) {
        print('Updated $_uuid');
        _isSaving = false;
        // TODO Handle failure.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.puzzle.name)),
      resizeToAvoidBottomInset: false,
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return Flex(
            direction: orientation == Orientation.portrait
                ? Axis.vertical
                : Axis.horizontal,
            children: [
              Expanded(
                  child: EditorPlacer(
                      editedGame: _editedGame,
                      onPlay: () => _handlePlay(context),
                      onSave: _handleSave,
                      onUndo: _editedGame.undo,
                      onRedo: _editedGame.redo,
                      menus: const [
                    EditorMenu(subMenu: [
                      EditorTool(
                          type: ToolType.tile,
                          tile: Rocket(player: PlayerColor.Blue)),
                      EditorTool(type: ToolType.tile, tile: Pit())
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
