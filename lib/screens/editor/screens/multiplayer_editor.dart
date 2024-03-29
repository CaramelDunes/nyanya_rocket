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
    super.key,
    required this.board,
    this.uuid,
  });

  @override
  State<MultiplayerEditor> createState() => _MultiplayerEditorState();
}

class _MultiplayerEditorState extends State<MultiplayerEditor> {
  late EditedGame _editedGame;
  late String? _uuid;

  bool _isSaving = false;

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
      appBar: AppBar(title: Text(widget.board.name)),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
              child: EditorPlacer(
                  editedGame: _editedGame,
                  onSave: _handleSave,
                  onUndo: _editedGame.undo,
                  onRedo: _editedGame.redo,
                  menus: const [
                EditorMenu(
                    subMenu: [EditorTool(type: ToolType.tile, tile: Pit())]),
                StandardMenus.rockets,
                StandardMenus.generators,
                StandardMenus.walls,
              ]))
        ],
      ),
    );
  }

  void _handleSave() {
    if (_isSaving) {
      return;
    }

    _isSaving = true;

    if (_uuid == null) {
      MultiplayerStore.saveNew(_buildMultiplayerBoard()).then((String? uuid) {
        if (uuid != null) {
          _uuid = uuid;
          print('Saved $uuid');
          _isSaving = false;
        } // FIXME Handle failure.
      });
    } else {
      MultiplayerStore.update(_uuid!, _buildMultiplayerBoard())
          .then((bool status) {
        print('Updated $_uuid');
        _isSaving = false;
        // FIXME Handle failure.
      });
    }
  }
}
