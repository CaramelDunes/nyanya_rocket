import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/named_puzzle_data.dart';
import 'package:nyanya_rocket/models/user.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle.dart';
import 'package:nyanya_rocket/widgets/empty_list.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../models/stores/puzzle_store.dart';

class LocalPuzzles extends StatefulWidget {
  @override
  _LocalPuzzlesState createState() => _LocalPuzzlesState();
}

class _LocalPuzzlesState extends State<LocalPuzzles> {
  Map<String, String> _puzzles = Map();

  @override
  void initState() {
    super.initState();

    PuzzleStore.registry().then((Map<String, String> entries) => setState(() {
          _puzzles = entries;
          print(_puzzles);
        }));
  }

  void _verifyAndPublish(BuildContext context, NamedPuzzleData puzzle) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Puzzle(
                  puzzle: puzzle,
                  onWin: (_) {
                    // FIXME
                    // FirebaseFunctions.instance
                    //     .httpsCallable('publishPuzzle')
                    //     .call({
                    //   'name': puzzle.name,
                    //   'puzzle_data': jsonEncode(puzzle.puzzleData.toJson()),
                    // }).then((HttpsCallableResult result) {
                    //   print(result.data);
                    // });
                    context
                        .read<User>()
                        .idToken()
                        .then((idToken) => http.post(
                            Uri.https(
                                'us-central1-nyanya-rocket.cloudfunctions.net',
                                '/publishPuzzle'),
                            headers: {
                              'Authorization': 'Bearer $idToken',
                              'Content-Type': 'application/json'
                            },
                            body: jsonEncode({
                              'data': {
                                'name': puzzle.name,
                                'puzzle_data':
                                    jsonEncode(puzzle.puzzleData.toJson()),
                              }
                            })))
                        .then((response) => response.statusCode == 200)
                        .then((success) {
                      if (success) {
                        final snackBar = SnackBar(
                            content: Text(NyaNyaLocalizations.of(context)
                                .publishSuccessText));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    });
                    // else {
                    //   final snackBar = SnackBar(
                    //       content: Text(
                    //           NyaNyaLocalizations.of(context).puzzleNotCompletedLocallyText));
                    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // }
                  },
                )));
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);

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
//                  IconButton(
//                    icon: Icon(Icons.share),
//                    onPressed: () {
//                      Share.share(
//                          'Check out this new puzzle I made! nyanya://puzzle/superjsonbase64');
//                    },
//                  ),
                  IconButton(
                    icon: Icon(Icons.publish),
                    tooltip: NyaNyaLocalizations.of(context).publishLabel,
                    onPressed: () {
                      if (user.isConnected) {
                        PuzzleStore.readPuzzle(uuidList[i])
                            .then((NamedPuzzleData? puzzle) {
                          if (puzzle != null)
                            _verifyAndPublish(context, puzzle);
                        });
                      } else {
                        final snackBar = SnackBar(
                            content: Text(NyaNyaLocalizations.of(context)
                                .loginPromptText));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                ],
              ),
              onTap: () {
                PuzzleStore.readPuzzle(uuidList[i])
                    .then((NamedPuzzleData? puzzle) {
                  if (puzzle != null)
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Puzzle(
                              puzzle: puzzle,
                              // hasNext: i != uuidList.length - 1, TODO
                            )));
                });
              },
            ));
  }
}
