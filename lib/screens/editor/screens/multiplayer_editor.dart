import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/screens/editor/edited_game.dart';
import 'package:nyanya_rocket/screens/editor/menus/standard_menus.dart';
import 'package:nyanya_rocket/screens/editor/widgets/editor_placer.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../models/stores/multiplayer_store.dart';

class MultiplayerEditor extends StatefulWidget {
  final MultiplayerBoard board;
  final String? uuid;

  const MultiplayerEditor({
    Key? key,
    required this.board,
    this.uuid,
  }) : super(key: key);

  @override
  _MultiplayerEditorState createState() => _MultiplayerEditorState();
}

class _MultiplayerEditorState extends State<MultiplayerEditor> {
  late EditedGame _editedGame;
  late String? _uuid;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _editedGame = EditedGame(game: GameState()..board = widget.board.board());

    _uuid = widget.uuid;
  }

  @override
  void dispose() {
    super.dispose();

    _editedGame.dispose();
  }

  MultiplayerBoard _buildMultiplayerBoard() {
    dynamic boardJson = _editedGame.game.board.toJson();

    return MultiplayerBoard(
      name: widget.board.name,
      boardData: jsonEncode(boardJson),
      maxPlayer: 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.board.name),
        actions: [
          IconButton(
              icon: const Icon(Icons.undo),
              onPressed: () {
                _editedGame.undo();
              }),
          IconButton(
              icon: const Icon(Icons.redo),
              onPressed: () {
                _editedGame.redo();
              })
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Expanded(
              child: EditorPlacer(
                  editedGame: _editedGame,
                  onSave: _handleSave,
                  menus: const [
                EditorMenu(subMenu: <EditorTool>[
                  EditorTool(type: ToolType.tile, tile: Pit())
                ]),
                StandardMenus.rockets,
                StandardMenus.generators,
                StandardMenus.walls,
              ]))
        ],
      ),
    );
  }

  void _handleSave() {
    if (_saving) {
      return;
    }

    _saving = true;

    if (_uuid == null) {
      MultiplayerStore.saveNewBoard(_buildMultiplayerBoard())
          .then((String? uuid) {
        if (uuid != null) {
          _uuid = uuid;
          print('Saved $uuid');
          _saving = false;
        } // FIXME Handle failure.
      });
    } else {
      MultiplayerStore.updateBoard(_uuid!, _buildMultiplayerBoard())
          .then((bool status) {
        print('Updated $_uuid');
        _saving = false;
        // FIXME Handle failure.
      });
    }
  }
}
