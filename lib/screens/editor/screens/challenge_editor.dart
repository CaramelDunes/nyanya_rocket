import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/models/named_challenge_data.dart';
import 'package:nyanya_rocket/screens/challenge/challenge.dart';
import 'package:nyanya_rocket/screens/challenges/tabs/local_challenges.dart';
import 'package:nyanya_rocket/screens/editor/editor_game_controller.dart';
import 'package:nyanya_rocket/screens/editor/menus/standard_menus.dart';
import 'package:nyanya_rocket/screens/editor/widgets/editor_placer.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class ChallengeEditor extends StatefulWidget {
  final NamedChallengeData challenge;
  final String uuid;

  ChallengeEditor({
    @required this.challenge,
    this.uuid,
  });

  @override
  _ChallengeEditorState createState() => _ChallengeEditorState();
}

class _ChallengeEditorState extends State<ChallengeEditor> {
  EditorGameController _editorGameController;
  String _uuid;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _editorGameController = EditorGameController(
        game: widget.challenge.challengeData.getGame(),
        gameSimulator: ChallengeGameSimulator());

    _uuid = widget.uuid;
  }

  @override
  void dispose() {
    super.dispose();

    _editorGameController.close();
  }

  NamedChallengeData _buildChallengeData() {
    dynamic gameJson = _editorGameController.game.toJson();

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
        break;

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
        break;

      case ChallengeType.LunchTime:
        return [
          EditorMenu(subMenu: <EditorTool>[
            EditorTool(type: ToolType.Tile, tile: Pit())
          ]),
          StandardMenus.mice,
          StandardMenus.cats,
          StandardMenus.walls,
        ];
        break;

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
        break;

      default:
        return [];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.challenge.name),
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Expanded(
              child: EditorPlacer(
            editorGameController: _editorGameController,
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
      LocalChallenges.store
          .saveNewChallenge(_buildChallengeData())
          .then((String uuid) {
        this._uuid = uuid;
        print('Saved $uuid');
        _saving = false;
      });
    } else {
      LocalChallenges.store
          .updateChallenge(_uuid, _buildChallengeData())
          .then((bool status) {
        print('Updated $_uuid');
        _saving = false;
      });
    }
  }
}
