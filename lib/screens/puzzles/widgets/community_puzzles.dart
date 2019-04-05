import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle.dart';
import 'package:nyanya_rocket/screens/puzzles/community_puzzle_data.dart';
import 'package:nyanya_rocket/widgets/success_overlay.dart';

class CommunityPuzzles extends StatefulWidget {
  @override
  _CommunityPuzzlesState createState() {
    return _CommunityPuzzlesState();
  }
}

enum _Sorting { ByDate, ByPopularity }

class _CommunityPuzzlesState extends State<CommunityPuzzles> {
  List<CommunityPuzzleData> puzzles = List();
  _Sorting _sorting = _Sorting.ByPopularity;

  @override
  void initState() {
    super.initState();

    Firestore.instance
        .collection('puzzles')
        .orderBy(_sorting == _Sorting.ByDate ? 'date' : 'likes',
            descending: true)
        .limit(10)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      puzzles.clear();

      puzzles = snapshot.documents
          .map<CommunityPuzzleData>((DocumentSnapshot snapshot) {
        return CommunityPuzzleData(
            puzzleData: snapshot.data['puzzle_data'],
            likes: snapshot.data['likes'],
            author: snapshot.data['author'],
            name: snapshot.data['name'],
            date: snapshot.data['date'].toDate());
      }).toList();

      setState(() {});
    });
  }

  void _handlePuzzleWin(int i, bool starred) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Flexible(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Sort by',
                  style: Theme.of(context).textTheme.subhead,
                ),
                VerticalDivider(),
                Expanded(
                  child: DropdownButton<_Sorting>(
                    isExpanded: true,
                    value: _sorting,
                    items: <DropdownMenuItem<_Sorting>>[
                      DropdownMenuItem<_Sorting>(
                        child: Text('Date'),
                        value: _Sorting.ByDate,
                      ),
                      DropdownMenuItem<_Sorting>(
                        child: Text('Name'),
                        value: _Sorting.ByPopularity,
                      )
                    ],
                    onChanged: (_Sorting value) => setState(() {
                          _sorting = value;
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(),
        Expanded(
          child: ListView.separated(
              separatorBuilder: (context, int) => Divider(),
              itemCount: puzzles.length,
              itemBuilder: (context, i) => ListTile(
                    title: Text(puzzles[i].name),
                    subtitle: Text(puzzles[i].author +
                        MaterialLocalizations.of(context)
                            .formatMediumDate(puzzles[i].date)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('${puzzles[i].likes}'),
                        ),
                        Icon(Icons.star),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute<OverlayPopData>(
                              builder: (context) => Puzzle(
                                    puzzle: PuzzleData.fromJson(
                                        jsonDecode(puzzles[i].puzzleData)),
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
