import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/screens/challenges/community_challenge_data.dart';

class CommunityChallenges extends StatefulWidget {
  @override
  _CommunityChallengesState createState() => _CommunityChallengesState();
}

enum _Sorting { ByDate, ByPopularity, ByName }

class _CommunityChallengesState extends State<CommunityChallenges> {
  List<CommunityChallengeData> challenges = [];
  _Sorting _sorting = _Sorting.ByPopularity;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  Future<void> _refreshList() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('challenges')
        .orderBy(
            _sorting == _Sorting.ByDate
                ? 'date'
                : _sorting == _Sorting.ByPopularity
                    ? 'likes'
                    : 'name',
            descending: _sorting != _Sorting.ByName)
        .limit(50)
        .get();

    List<CommunityChallengeData> newChallenges =
        snapshot.docs.map<CommunityChallengeData>((DocumentSnapshot snapshot) {
      return CommunityChallengeData(
          uid: snapshot.id,
          challengeData: ChallengeData.fromJson(
              jsonDecode(snapshot.get('challenge_data'))),
          likes: snapshot.get('likes'),
          author: snapshot.get('author_name'),
          name: snapshot.get('name'),
          date: snapshot.get('date').toDate());
    }).toList();

    if (mounted) {
      setState(() {
        challenges = newChallenges;
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
                    if (value != null) {
                      setState(() {
                        _sorting = value;
                        _refreshList();
                      });
                    }
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
                itemCount: challenges.length,
                itemBuilder: (context, i) => ListTile(
                      title: Text(challenges[i].name),
                      subtitle: Text(
                          '${challenges[i].author}\n${MaterialLocalizations.of(context).formatMediumDate(challenges[i].date)}'),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('${challenges[i].likes}'),
                          ),
                          Icon(Icons.star),
                        ],
                      ),
                      onTap: () {
                        Router.of(context).routerDelegate.setNewRoutePath(
                            NyaNyaRoutePath.communityChallenge(
                                challenges[i].uid));
                      },
                    )),
          ),
        ),
      ],
    );
  }
}
