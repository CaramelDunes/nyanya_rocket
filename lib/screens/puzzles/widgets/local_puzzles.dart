import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:nyanya_rocket/models/puzzle_store.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle.dart';

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

  @override
  Widget build(BuildContext context) {
    List<String> uuidList = _puzzles.keys.toList();

    return ListView.separated(
        separatorBuilder: (context, int) => Divider(),
        itemCount: _puzzles.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(_puzzles[uuidList[i]]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
              ),
              onTap: () {
                LocalPuzzles.store.readPuzzle(uuidList[i]).then(
                    (PuzzleData puzzle) =>
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Puzzle(
                                  puzzle: puzzle,
                                ))));
              },
            ));
  }
}
