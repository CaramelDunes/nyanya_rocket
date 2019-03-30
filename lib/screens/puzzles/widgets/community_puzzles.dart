import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle.dart';
import 'package:nyanya_rocket/screens/puzzles/community_puzzle_data.dart';
import 'package:nyanya_rocket/widgets/success_overlay.dart';

class CommunityPuzzles extends StatefulWidget {
  @override
  _CommunityPuzzlesState createState() {
    return _CommunityPuzzlesState();
  }
}

class _CommunityPuzzlesState extends State<CommunityPuzzles> {
  List<CommunityPuzzleData> puzzles = List();
  int i = 0;

  @override
  void initState() {
    super.initState();

    Firestore.instance
        .collection('puzzles')
        .orderBy('date', descending: true)
        .limit(10)
        .getDocuments();
  }

  void _handlePuzzleWin(int i, bool starred) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<int>(
            isExpanded: true,
            value: i,
            items: <DropdownMenuItem<int>>[
              DropdownMenuItem<int>(
                child: Text('Date'),
                value: 1,
              ),
              DropdownMenuItem<int>(
                child: Text('Name'),
                value: 0,
              )
            ],
            onChanged: (int value) => setState(() {
                  i = value;
                }),
          ),
        ),
        Expanded(
          child: ListView.separated(
              separatorBuilder: (context, int) => Divider(),
              itemCount: puzzles.length,
              itemBuilder: (context, i) => ListTile(
                    title: Text(puzzles[i].name),
                    subtitle: Text(puzzles[i].author),
                    trailing: Row(),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute<OverlayPopData>(
                              builder: (context) => Puzzle(
                                    puzzle: puzzles[i],
                                    onWin: (bool starred) =>
                                        _handlePuzzleWin(i, starred),
                                  )))
                          .then((OverlayPopData popData) {});
                    },
                  )),
        ),
      ],
    );
  }
}
