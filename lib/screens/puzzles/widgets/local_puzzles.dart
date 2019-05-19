import 'dart:collection';
import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/named_puzzle_data.dart';
import 'package:nyanya_rocket/models/puzzle_store.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle.dart';
import 'package:nyanya_rocket/screens/settings/account_management.dart';
import 'package:nyanya_rocket/widgets/empty_list.dart';
import 'package:nyanya_rocket/widgets/success_overlay.dart';

class LocalPuzzles extends StatefulWidget {
  static final PuzzleStore store = PuzzleStore();

  @override
  _LocalPuzzlesState createState() {
    return _LocalPuzzlesState();
  }
}

class _LocalPuzzlesState extends State<LocalPuzzles> {
  HashMap<String, String> _puzzles = HashMap();

  @override
  void initState() {
    super.initState();

    LocalPuzzles.store.readRegistry().then((HashMap entries) => setState(() {
          _puzzles = entries;
        }));
  }

  void _verifyAndPublish(BuildContext context, NamedPuzzleData puzzle) {
    Navigator.push<OverlayPopData>(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Puzzle(
                  puzzle: puzzle,
                  hasNext: false,
                ))).then((OverlayPopData popData) {
      if (popData != null) {
        CloudFunctions.instance
            .getHttpsCallable(functionName: 'publishPuzzle')
            .call({
          'name': puzzle.name,
          'puzzle_data': jsonEncode(puzzle.puzzleData.toJson()),
        }).then((HttpsCallableResult result) {
          print(result.data);
        });

        final snackBar = SnackBar(
            content: Text(NyaNyaLocalizations.of(context).publishSuccessText));
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(
            content: Text(
                NyaNyaLocalizations.of(context).puzzleNotCompletedLocallyText));
        Scaffold.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> uuidList = _puzzles.keys.toList();

    if (uuidList.isEmpty) {
      return Center(child: EmptyList());
    }

    return ListView.separated(
        separatorBuilder: (context, int) => Divider(),
        itemCount: _puzzles.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(_puzzles[uuidList[i]]),
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
                      if (AccountManagement.user.isConnected) {
                        LocalPuzzles.store.readPuzzle(uuidList[i]).then(
                            (NamedPuzzleData puzzle) =>
                                _verifyAndPublish(context, puzzle));
                      } else {
                        final snackBar = SnackBar(
                            content: Text(NyaNyaLocalizations.of(context)
                                .loginPromptText));
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                ],
              ),
              onTap: () {
                LocalPuzzles.store.readPuzzle(uuidList[i]).then(
                    (NamedPuzzleData puzzle) =>
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Puzzle(
                                  puzzle: puzzle,
                                  hasNext: i != uuidList.length - 1,
                                ))));
              },
            ));
  }
}
