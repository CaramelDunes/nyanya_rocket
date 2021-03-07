import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/screens/puzzles/community_puzzle_data.dart';

class CommunityPuzzles extends StatefulWidget {
  @override
  _CommunityPuzzlesState createState() => _CommunityPuzzlesState();
}

enum _Sorting { ByDate, ByPopularity, ByName }

class _CommunityPuzzlesState extends State<CommunityPuzzles> {
  List<CommunityPuzzleData> puzzles = [];
  _Sorting _sorting = _Sorting.ByPopularity;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  Future<void> _refreshList() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('puzzles')
        .orderBy(
            _sorting == _Sorting.ByDate
                ? 'date'
                : _sorting == _Sorting.ByPopularity
                    ? 'likes'
                    : 'name',
            descending: _sorting != _Sorting.ByName)
        .limit(50)
        .get();

    List<CommunityPuzzleData> newPuzzles =
        snapshot.docs.map<CommunityPuzzleData>((DocumentSnapshot snapshot) {
      return CommunityPuzzleData(
          uid: snapshot.id,
          puzzleData:
              PuzzleData.fromJson(jsonDecode(snapshot.get('puzzle_data'))),
          likes: snapshot.get('likes'),
          author: snapshot.get('author_name'),
          name: snapshot.get('name'),
          date: snapshot.get('date').toDate());
    }).toList();

    if (mounted) {
      setState(() {
        puzzles = newPuzzles;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                NyaNyaLocalizations.of(context).sortByLabel,
                style: Theme.of(context).textTheme.subtitle1,
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
                      child:
                          Text(NyaNyaLocalizations.of(context).popularityLabel),
                      value: _Sorting.ByPopularity,
                    )
                  ],
                  onChanged: (_Sorting? value) {
                    setState(() {
                      _sorting = value ?? _sorting;
                      _refreshList();
                    });
                  },
                ),
              ),
            ],
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
                        Router.of(context).routerDelegate.setNewRoutePath(
                            NyaNyaRoutePath.communityPuzzle(puzzles[i].uid));
                      },
                    )),
          ),
        ),
      ],
    );
  }
}
