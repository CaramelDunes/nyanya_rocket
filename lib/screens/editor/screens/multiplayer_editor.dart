import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/screens/editor/edited_game.dart';
import 'package:nyanya_rocket/screens/editor/menus/standard_menus.dart';
import 'package:nyanya_rocket/screens/editor/widgets/editor_placer.dart';
import 'package:nyanya_rocket/screens/multiplayer/picker_tabs/local_boards.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class MultiplayerEditor extends StatefulWidget {
  final MultiplayerBoard board;
  final String uuid;

  MultiplayerEditor({
    @required this.board,
    this.uuid,
  });

  @override
  _MultiplayerEditorState createState() => _MultiplayerEditorState();
}

class _MultiplayerEditorState extends State<MultiplayerEditor> {
  EditedGame _editorGameController;
  String _uuid;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _editorGameController =
        EditedGame(game: GameState()..board = widget.board.board());

    _uuid = widget.uuid;
  }

  @override
  void dispose() {
    super.dispose();

    _editorGameController.dispose();
  }

  MultiplayerBoard _buildMultiplayerBoard() {
    dynamic boardJson = _editorGameController.game.board.toJson();

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
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Expanded(
              child: EditorPlacer(
                  editedGame: _editorGameController,
                  onSave: _handleSave,
                  menus: [
                EditorMenu(subMenu: <EditorTool>[
                  EditorTool(type: ToolType.Tile, tile: Pit())
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
      LocalBoards.store
          .saveNewBoard(_buildMultiplayerBoard())
          .then((String uuid) {
        _uuid = uuid;
        print('Saved $uuid');
        _saving = false;
      });
    } else {
      LocalBoards.store
          .updateBoard(_uuid, _buildMultiplayerBoard())
          .then((bool status) {
        print('Updated $_uuid');
        _saving = false;
      });
    }
  }
}
