import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
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

enum _Sorting { ByDate, ByPopularity, ByName }

class _CommunityPuzzlesState extends State<CommunityPuzzles> {
  List<CommunityPuzzleData> puzzles = List();
  _Sorting _sorting = _Sorting.ByPopularity;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  Future<void> _refreshList() async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('puzzles')
        .orderBy(
            _sorting == _Sorting.ByDate
                ? 'date'
                : _sorting == _Sorting.ByPopularity ? 'likes' : 'name',
            descending: _sorting != _Sorting.ByName)
        .limit(50)
        .getDocuments();

    List<CommunityPuzzleData> newPuzzles = snapshot.documents
        .map<CommunityPuzzleData>((DocumentSnapshot snapshot) {
      return CommunityPuzzleData(
          uid: snapshot.documentID,
          puzzleData:
              PuzzleData.fromJson(jsonDecode(snapshot.data['puzzle_data'])),
          likes: snapshot.data['likes'],
          author: snapshot.data['author_name'],
          name: snapshot.data['name'],
          date: snapshot.data['date'].toDate());
    }).toList();

    if (mounted) {
      setState(() {
        puzzles = newPuzzles;
      });
    }
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
                  NyaNyaLocalizations.of(context).sortByLabel,
                  style: Theme.of(context).textTheme.subhead,
                ),
                VerticalDivider(),
                Expanded(
                  child: DropdownButton<_Sorting>(
                    isExpanded: true,
                    value: _sorting,
                    items: <DropdownMenuItem<_Sorting>>[
                      DropdownMenuItem<_Sorting>(
                        child: Text(NyaNyaLocalizations.of(context).dateLabel),
                        value: _Sorting.ByDate,
                      ),
                      DropdownMenuItem<_Sorting>(
                        child: Text(NyaNyaLocalizations.of(context).nameLabel),
                        value: _Sorting.ByName,
                      ),
                      DropdownMenuItem<_Sorting>(
                        child: Text(
                            NyaNyaLocalizations.of(context).popularityLabel),
                        value: _Sorting.ByPopularity,
                      )
                    ],
                    onChanged: (_Sorting value) {
                      setState(() {
                        _sorting = value;
                        _refreshList();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshList,
            child: ListView.separated(
                separatorBuilder: (context, int) => Divider(),
                itemCount: puzzles.length,
                itemBuilder: (context, i) => ListTile(
                      title: Text(puzzles[i].name),
                      subtitle: Text(
                          '${puzzles[i].author}\n${MaterialLocalizations.of(context).formatMediumDate(puzzles[i].date)}'),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('${puzzles[i].likes}'),
                          ),
                          Icon(Icons.star),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute<OverlayPopData>(
                                builder: (context) => Puzzle(
                                      puzzle: puzzles[i],
                                      onWin: (bool starred) =>
                                          _handlePuzzleWin(i, starred),
                                      documentPath: 'puzzles/${puzzles[i].uid}',
                                      hasNext: false,
                                    )))
                            .then((OverlayPopData popData) {});
                      },
                    )),
          ),
        ),
      ],
    );
  }
}
