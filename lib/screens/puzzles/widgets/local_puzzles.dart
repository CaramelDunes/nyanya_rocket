import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:nyanya_rocket/models/puzzle_store.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle.dart';
import 'package:nyanya_rocket/widgets/empty_list.dart';

class LocalPuzzles extends StatefulWidget {
  static final PuzzleStore store = PuzzleStore();

  @override
  _LocalPuzzlesState createState() {
    return _LocalPuzzlesState();
  }
}

class _LocalPuzzlesState extends State<LocalPuzzles> {
  HashMap<String, String> _puzzles = HashMap();
  FirebaseUser user;

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

    if (uuidList.isEmpty) {
      return Center(child: EmptyList());
    }

    return ListView.separated(
        separatorBuilder: (context, int) => Divider(),
        itemCount: _puzzles.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(_puzzles[uuidList[i]]),
              trailing: IconButton(
                icon: Icon(Icons.publish),
                onPressed: () {
                  final FirebaseAuth _auth = FirebaseAuth.instance;

                  _auth.signInAnonymously().then((FirebaseUser user) {
                    if (user == null) return;
                    print(user.uid);
                    LocalPuzzles.store.readPuzzle(uuidList[i]).then(
                        (PuzzleData puzzle) => Firestore.instance
                                .collection('puzzles')
                                .document()
                                .setData({
                              'name': _puzzles[uuidList[i]],
                              'author': user.uid,
                              'puzzle_data': jsonEncode(puzzle.toJson()),
                              'date': Timestamp.now(),
                              'likes': 0
                            }));
                  });
                },
              ),
              onTap: () {
                LocalPuzzles.store.readPuzzle(uuidList[i]).then(
                    (PuzzleData puzzle) =>
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Puzzle(
                                  puzzle: puzzle,
                                  hasNext: i != uuidList.length - 1,
                                ))));
              },
            ));
  }
}
