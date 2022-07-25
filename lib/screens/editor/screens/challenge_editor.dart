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

  const ChallengeEditor({
    Key? key,
    required this.challenge,
    this.uuid,
  }) : super(key: key);

  @override
  State<ChallengeEditor> createState() => _ChallengeEditorState();
}

class _ChallengeEditorState extends State<ChallengeEditor> {
  late EditedGame _editedGame;
  String? _uuid;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _editedGame = EditedGame(game: widget.challenge.data.getGame());

    _uuid = widget.uuid;
  }

  @override
  void dispose() {
    _editedGame.dispose();

    super.dispose();
  }

  NamedChallengeData _buildChallengeData() {
    dynamic gameJson = _editedGame.game.toJson();

    return NamedChallengeData.fromGameData(
      name: widget.challenge.name,
      type: widget.challenge.data.type,
      gameData: jsonEncode(gameJson),
    );
  }

  List<EditorMenu> _menusForType(ChallengeType type) {
    switch (type) {
      case ChallengeType.getMice:
        return [
          const EditorMenu(subMenu: [
            EditorTool(
                type: ToolType.tile, tile: Rocket(player: PlayerColor.Blue)),
            EditorTool(type: ToolType.tile, tile: Pit())
          ]),
          StandardMenus.mice,
          StandardMenus.walls,
        ];

      case ChallengeType.runAway:
        return [
          const EditorMenu(subMenu: [
            EditorTool(
                type: ToolType.tile, tile: Rocket(player: PlayerColor.Blue)),
            EditorTool(type: ToolType.tile, tile: Pit())
          ]),
          StandardMenus.mice,
          StandardMenus.cats,
          StandardMenus.walls,
        ];

      case ChallengeType.lunchTime:
        return [
          const EditorMenu(
              subMenu: [EditorTool(type: ToolType.tile, tile: Pit())]),
          StandardMenus.mice,
          StandardMenus.cats,
          StandardMenus.walls,
        ];

      case ChallengeType.oneHundredMice:
        return [
          const EditorMenu(subMenu: [
            EditorTool(
                type: ToolType.tile, tile: Rocket(player: PlayerColor.Blue)),
            EditorTool(type: ToolType.tile, tile: Pit())
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
      appBar: AppBar(title: Text(widget.challenge.name)),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
              child: EditorPlacer(
            editedGame: _editedGame,
            menus: _menusForType(widget.challenge.data.type),
            onPlay: () => _handlePlay(context),
            onSave: _handleSave,
            onUndo: _editedGame.undo,
            onRedo: _editedGame.redo,
          )),
        ],
      ),
    );
  }

  void _handlePlay(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext _) => Challenge(
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
          _uuid = uuid;
          print('Saved $uuid');
          _saving = false;
        } // FIXME Handle failure.
      });
    } else {
      ChallengeStore.update(_uuid!, _buildChallengeData()).then((bool status) {
        // FIXME Handle failure.
        print('Updated $_uuid');
        _saving = false;
      });
    }
  }
}
