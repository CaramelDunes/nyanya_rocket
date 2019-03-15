import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/models/multiplayer_store.dart';
import 'package:nyanya_rocket/screens/editor/editor_game_controller.dart';
import 'package:nyanya_rocket/screens/editor/menus/standard_menus.dart';
import 'package:nyanya_rocket/screens/editor/widgets/discard_confirmation_dialog.dart';
import 'package:nyanya_rocket/screens/editor/widgets/editor_placer.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class MultiplayerEditor extends StatefulWidget {
  static final MultiplayerStore store = MultiplayerStore();

  final MultiplayerBoard board;
  final String uuid;

  MultiplayerEditor({
    @required this.board,
    this.uuid,
  });

  @override
  _MultiplayerEditorState createState() {
    return _MultiplayerEditorState();
  }
}

class _MultiplayerEditorState extends State<MultiplayerEditor> {
  EditorGameController _editorGameController;
  String uuid;

  @override
  void initState() {
    super.initState();

    _editorGameController =
        EditorGameController(game: Game()..board = widget.board.board());

    uuid = widget.uuid;
  }

  @override
  void dispose() {
    super.dispose();

    _editorGameController.close();
  }

  MultiplayerBoard _buildMultiplayerBoard() {
    dynamic boardJson = _editorGameController.game.board.toJson();

    return MultiplayerBoard(
      name: widget.board.name,
      boardData: jsonEncode(boardJson),
      maxPlayer: 3,
    );
  }

  Future<bool> _confirmDiscard() {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const DiscardConfirmationDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmDiscard,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.board.name),
        ),
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            Expanded(
                child: EditorPlacer(
                    editorGameController: _editorGameController,
                    menus: [
                  EditorMenu(subMenu: <EditorTool>[
                    EditorTool(type: ToolType.Tile, tile: Pit())
                  ]),
                  StandardMenus.rockets,
                  StandardMenus.generators,
                  StandardMenus.walls,
                  StandardMenus.eraser,
                ])),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text("Save"),
                  onPressed: () {
                    if (uuid == null) {
                      MultiplayerEditor.store
                          .saveNewBoard(_buildMultiplayerBoard())
                          .then((String uuid) {
                        this.uuid = uuid;
                        print('Saved $uuid');
                      });
                    } else {
                      MultiplayerEditor.store
                          .updateBoard(uuid, _buildMultiplayerBoard())
                          .then((bool status) {
                        print('Updated $uuid');
                      });
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
