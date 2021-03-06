import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/models/named_challenge_data.dart';
import 'package:nyanya_rocket/models/named_puzzle_data.dart';
import 'package:nyanya_rocket/screens/editor/screens/challenge_editor.dart';
import 'package:nyanya_rocket/screens/editor/screens/multiplayer_editor.dart';
import 'package:nyanya_rocket/screens/editor/screens/puzzle_editor.dart';
import 'package:nyanya_rocket/screens/editor/widgets/name_field.dart';
import 'package:nyanya_rocket/widgets/empty_list.dart';

import '../../../models/stores/puzzle_store.dart';
import '../../../models/stores/multiplayer_store.dart';
import '../../../models/stores/challenge_store.dart';

enum EditorMode { Puzzle, Challenge, Multiplayer }

class EditTab extends StatefulWidget {
  @override
  _EditTabState createState() => _EditTabState();
}

class _EditTabState extends State<EditTab> {
  Map<String, String> _puzzles = HashMap();
  Map<String, String> _challenges = HashMap();
  Map<String, String> _multiplayerBoards = HashMap();
  String? name;
  EditorMode _mode = EditorMode.Puzzle;

  @override
  void initState() {
    super.initState();

    PuzzleStore.registry().then((Map<String, String> entries) => setState(() {
          _puzzles = entries;
        })); // TODO Use FutureBuilder.

    ChallengeStore.registry()
        .then((Map<String, String> entries) => setState(() {
              _challenges = entries;
            }));

    MultiplayerStore.registry()
        .then((Map<String, String> entries) => setState(() {
              _multiplayerBoards = entries;
            }));
  }

  void _showNameChangeDialog(BuildContext context, String uuid) {
    String? _name;
    final _formKey = GlobalKey<FormState>();

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Form(
            key: _formKey,
            child: NameFormField(
              onSaved: (String? newValue) {
                _name = newValue;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(NyaNyaLocalizations.of(context).accept.toUpperCase()),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.pop(context, _name);
                }
              },
            ),
            TextButton(
              child: Text(NyaNyaLocalizations.of(context).cancel.toUpperCase()),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    ).then((String? newName) {
      if (newName != null) {
        Future<bool> Function(String, String) renameFunction;
        Map<String, String> activeRegistry;

        switch (_mode) {
          case EditorMode.Puzzle:
            renameFunction = PuzzleStore.rename;
            activeRegistry = _puzzles;
            break;
          case EditorMode.Challenge:
            renameFunction = ChallengeStore.rename;
            activeRegistry = _challenges;
            break;
          case EditorMode.Multiplayer:
            renameFunction = MultiplayerStore.rename;
            activeRegistry = _multiplayerBoards;
            break;
        }

        renameFunction(uuid, newName).then((bool status) {
          setState(() {
            activeRegistry[uuid] = newName;
          });
        });
      }
    });
  }

  Widget _puzzleListView() {
    List<String> uuidList = _puzzles.keys.toList().reversed.toList();

    if (uuidList.isEmpty) {
      return Center(child: EmptyList());
    }

    return ListView.separated(
        separatorBuilder: (context, int) => Divider(),
        itemCount: _puzzles.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(_puzzles[uuidList[i]]!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.text_format),
                    onPressed: () {
                      _showNameChangeDialog(context, uuidList[i]);
                    },
                  ),
//                  IconButton(
//                    icon: Icon(Icons.content_copy),
//                    onPressed: () {
//                      PuzzleStore.readPuzzle(uuidList[i]).then(
//                          (NamedPuzzleData puzzle) => Clipboard.setData(
//                              ClipboardData(
//                                  text: jsonEncode(puzzle.toJson()))));
//                    },
//                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      PuzzleStore.deletePuzzle(uuidList[i]).then((bool result) {
                        if (result) // FIXME Handle failure.
                          setState(() {
                            _puzzles.remove(uuidList[i]);
                          });
                      });
                    },
                  ),
                ],
              ),
              onTap: () {
                PuzzleStore.readPuzzle(uuidList[i])
                    .then((NamedPuzzleData? puzzle) {
                  if (puzzle != null)
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PuzzleEditor(puzzle: puzzle, uuid: uuidList[i])));
                  else
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Couldn\'t read puzzle data.')));
                });
              },
            ));
  }

  Widget _challengeListView() {
    List<String> uuidList = _challenges.keys.toList();

    if (uuidList.isEmpty) {
      return Center(child: EmptyList());
    }

    return ListView.separated(
        separatorBuilder: (context, int) => Divider(),
        itemCount: _challenges.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(_challenges[uuidList[i]]!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.text_format),
                    onPressed: () {
                      _showNameChangeDialog(context, uuidList[i]);
                    },
                  ),
//                  IconButton(
//                    icon: Icon(Icons.content_copy),
//                    onPressed: () {
//                      ChallengeStore.readChallenge(uuidList[i]).then(
//                          (NamedChallengeData challenge) => Clipboard.setData(
//                              ClipboardData(
//                                  text: challenge.challengeData.gameData)));
//                    },
//                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      ChallengeStore.deleteChallenge(uuidList[i])
                          .then((bool result) => setState(() {}));
                    },
                  ),
                ],
              ),
              onTap: () {
                ChallengeStore.readChallenge(uuidList[i])
                    .then((NamedChallengeData? challenge) {
                  if (challenge != null)
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChallengeEditor(
                            challenge: challenge, uuid: uuidList[i])));
                });
              },
            ));
  }

  Widget _multiplayerBoardsListView() {
    List<String> uuidList = _multiplayerBoards.keys.toList();

    if (uuidList.isEmpty) {
      return Center(child: EmptyList());
    }

    return ListView.separated(
        separatorBuilder: (context, int) => Divider(),
        itemCount: _multiplayerBoards.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(_multiplayerBoards[uuidList[i]]!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.text_format),
                    onPressed: () {
                      _showNameChangeDialog(context, uuidList[i]);
                    },
                  ),
//                  IconButton(
//                    icon: Icon(Icons.content_copy),
//                    onPressed: () {
//                      MultiplayerStore.readBoard(uuidList[i]).then(
//                          (MultiplayerBoard multiplayerBoard) =>
//                              Clipboard.setData(ClipboardData(
//                                  text: multiplayerBoard.boardData)));
//                    },
//                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      MultiplayerStore.deleteBoard(uuidList[i])
                          .then((bool result) => setState(() {}));
                    },
                  ),
                ],
              ),
              onTap: () {
                MultiplayerStore.readBoard(uuidList[i])
                    .then((MultiplayerBoard? board) {
                  if (board != null)
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MultiplayerEditor(
                            board: board, uuid: uuidList[i])));
                });
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
                child: Text(NyaNyaLocalizations.of(context).puzzleType),
                value: EditorMode.Puzzle,
              ),
              DropdownMenuItem(
                child: Text(NyaNyaLocalizations.of(context).challengeType),
                value: EditorMode.Challenge,
              ),
              DropdownMenuItem(
                child: Text(NyaNyaLocalizations.of(context).multiplayerType),
                value: EditorMode.Multiplayer,
              ),
            ],
            onChanged: (EditorMode? value) => setState(() {
              _mode = value ?? _mode;
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
