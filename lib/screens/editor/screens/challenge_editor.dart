import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/models/named_challenge_data.dart';
import 'package:nyanya_rocket/screens/challenge/challenge.dart';
import 'package:nyanya_rocket/screens/editor/edited_game.dart';
import 'package:nyanya_rocket/screens/editor/menus/standard_menus.dart';
import 'package:nyanya_rocket/screens/editor/widgets/editor_placer.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../models/stores/challenge_store.dart';

class ChallengeEditor extends StatefulWidget {
  final NamedChallengeData challenge;
  final String? uuid;

  ChallengeEditor({
    required this.challenge,
    this.uuid,
  });

  @override
  _ChallengeEditorState createState() => _ChallengeEditorState();
}

class _ChallengeEditorState extends State<ChallengeEditor> {
  late EditedGame _editedGame;
  String? _uuid;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _editedGame = EditedGame(game: widget.challenge.challengeData.getGame());

    _uuid = widget.uuid;
  }

  @override
  void dispose() {
    _editedGame.dispose();

    super.dispose();
  }

  NamedChallengeData _buildChallengeData() {
    dynamic gameJson = _editedGame.game.toJson();

    return NamedChallengeData(
      name: widget.challenge.name,
      type: widget.challenge.challengeData.type,
      gameData: jsonEncode(gameJson),
    );
  }

  List<EditorMenu> _menusForType(ChallengeType type) {
    switch (type) {
      case ChallengeType.GetMice:
        return [
          EditorMenu(subMenu: <EditorTool>[
            EditorTool(
                type: ToolType.Tile, tile: Rocket(player: PlayerColor.Blue)),
            EditorTool(type: ToolType.Tile, tile: Pit())
          ]),
          StandardMenus.mice,
          StandardMenus.walls,
        ];

      case ChallengeType.RunAway:
        return [
          EditorMenu(subMenu: <EditorTool>[
            EditorTool(
                type: ToolType.Tile, tile: Rocket(player: PlayerColor.Blue)),
            EditorTool(type: ToolType.Tile, tile: Pit())
          ]),
          StandardMenus.mice,
          StandardMenus.cats,
          StandardMenus.walls,
        ];

      case ChallengeType.LunchTime:
        return [
          EditorMenu(subMenu: <EditorTool>[
            EditorTool(type: ToolType.Tile, tile: Pit())
          ]),
          StandardMenus.mice,
          StandardMenus.cats,
          StandardMenus.walls,
        ];

      case ChallengeType.OneHundredMice:
        return [
          EditorMenu(subMenu: <EditorTool>[
            EditorTool(
                type: ToolType.Tile, tile: Rocket(player: PlayerColor.Blue)),
            EditorTool(type: ToolType.Tile, tile: Pit())
          ]),
          StandardMenus.generators,
          StandardMenus.walls,
        ];

      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.challenge.name),
        actions: [
          IconButton(
              icon: Icon(Icons.undo),
              onPressed: () {
                _editedGame.undo();
              }),
          IconButton(
              icon: Icon(Icons.redo),
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
            menus: _menusForType(widget.challenge.challengeData.type),
            onPlay: () => _handlePlay(context),
            onSave: _handleSave,
          )),
        ],
      ),
    );
  }

  void _handlePlay(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext _) => Challenge(
              hasNext: false,
              challenge: _buildChallengeData(),
            )));
  }

  void _handleSave() {
    if (_saving) {
      return;
    }

    _saving = true;

    if (_uuid == null) {
      ChallengeStore.saveNew(_buildChallengeData()).then((String? uuid) {
        if (uuid != null) {
          this._uuid = uuid;
          print('Saved $uuid');
          _saving = false;
        } // FIXME Handle failure.
      });
    } else {
      ChallengeStore.updateChallenge(_uuid!, _buildChallengeData())
          .then((bool status) {
        // FIXME Handle failure.
        print('Updated $_uuid');
        _saving = false;
      });
    }
  }
}
