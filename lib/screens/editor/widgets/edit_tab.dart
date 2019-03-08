import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:nyanya_rocket/screens/challenges/tabs/local_challenges.dart';
import 'package:nyanya_rocket/screens/editor/screens/challenge_editor.dart';
import 'package:nyanya_rocket/screens/editor/screens/multiplayer_editor.dart';
import 'package:nyanya_rocket/screens/editor/screens/puzzle_editor.dart';
import 'package:nyanya_rocket/screens/multiplayer/multiplayer.dart';
import 'package:nyanya_rocket/screens/puzzles/widgets/local_puzzles.dart';

enum EditorMode { Puzzle, Challenge, Multiplayer }

class EditTab extends StatefulWidget {
  @override
  EditTabState createState() {
    return new EditTabState();
  }
}

class EditTabState extends State<EditTab> {
  HashMap<String, String> _puzzles = HashMap();
  HashMap<String, String> _challenges = HashMap();
  HashMap<String, String> _multiplayerBoards = HashMap();
  String name;
  EditorMode _mode = EditorMode.Puzzle;

  @override
  void initState() {
    super.initState();

    LocalPuzzles.store.readRegistry().then((HashMap entries) => setState(() {
          _puzzles = entries;
        }));

    LocalChallenges.store.readRegistry().then((HashMap entries) => setState(() {
          _challenges = entries;
        }));

    Multiplayer.store.readRegistry().then((HashMap entries) => setState(() {
          _multiplayerBoards = entries;
        }));
  }

  Widget _puzzleListView() {
    List<String> uuidList = _puzzles.keys.toList();

    return ListView.separated(
        separatorBuilder: (context, int) => Divider(),
        itemCount: _puzzles.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(_puzzles[uuidList[i]]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.content_copy),
                    onPressed: () {
                      LocalPuzzles.store.readPuzzle(uuidList[i]).then(
                          (PuzzleData puzzle) => Clipboard.setData(
                              ClipboardData(text: puzzle.gameData)));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      LocalPuzzles.store
                          .deletePuzzle(uuidList[i])
                          .then((bool result) => setState(() {}));
                    },
                  ),
                ],
              ),
              onTap: () {
                LocalPuzzles.store.readPuzzle(uuidList[i]).then(
                    (PuzzleData puzzle) => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => PuzzleEditor(
                                puzzle: puzzle, uuid: uuidList[i]))));
              },
            ));
  }

  Widget _challengeListView() {
    List<String> uuidList = _challenges.keys.toList();

    return ListView.separated(
        separatorBuilder: (context, int) => Divider(),
        itemCount: _challenges.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(_challenges[uuidList[i]]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.content_copy),
                    onPressed: () {
                      LocalChallenges.store.readChallenge(uuidList[i]).then(
                          (ChallengeData challenge) => Clipboard.setData(
                              ClipboardData(text: challenge.gameData)));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      LocalChallenges.store
                          .deleteChallenge(uuidList[i])
                          .then((bool result) => setState(() {}));
                    },
                  ),
                ],
              ),
              onTap: () {
                LocalChallenges.store.readChallenge(uuidList[i]).then(
                    (ChallengeData challenge) => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ChallengeEditor(
                                challenge: challenge, uuid: uuidList[i]))));
              },
            ));
  }

  Widget _multiplayerBoardsListView() {
    List<String> uuidList = _multiplayerBoards.keys.toList();

    return ListView.separated(
        separatorBuilder: (context, int) => Divider(),
        itemCount: _multiplayerBoards.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(_multiplayerBoards[uuidList[i]]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.content_copy),
                    onPressed: () {
                      Multiplayer.store.readBoard(uuidList[i]).then(
                          (MultiplayerBoard multiplayerBoard) =>
                              Clipboard.setData(ClipboardData(
                                  text: multiplayerBoard.boardData)));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      Multiplayer.store
                          .deleteBoard(uuidList[i])
                          .then((bool result) => setState(() {}));
                    },
                  ),
                ],
              ),
              onTap: () {
                Multiplayer.store.readBoard(uuidList[i]).then(
                    (MultiplayerBoard board) => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => MultiplayerEditor(
                                board: board, uuid: uuidList[i]))));
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<EditorMode>(
            isExpanded: true,
            value: _mode,
            items: <DropdownMenuItem<EditorMode>>[
              DropdownMenuItem(
                child: Text('Puzzle'),
                value: EditorMode.Puzzle,
              ),
              DropdownMenuItem(
                child: Text('Challenge'),
                value: EditorMode.Challenge,
              ),
              DropdownMenuItem(
                child: Text('Multiplayer'),
                value: EditorMode.Multiplayer,
              ),
            ],
            onChanged: (EditorMode value) => setState(() {
                  _mode = value;
                }),
          ),
        ),
        Expanded(
            child: _mode == EditorMode.Puzzle
                ? _puzzleListView()
                : _mode == EditorMode.Challenge
                    ? _challengeListView()
                    : _multiplayerBoardsListView()),
      ],
    );
  }
}
