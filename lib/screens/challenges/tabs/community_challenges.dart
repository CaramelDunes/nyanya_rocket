import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/screens/challenges/community_challenge_data.dart';
import '../../../services/firebase/firebase_service.dart';

class CommunityChallenges extends StatefulWidget {
  @override
  _CommunityChallengesState createState() => _CommunityChallengesState();
}

class _CommunityChallengesState extends State<CommunityChallenges> {
  List<CommunityChallengeData> challenges = [];
  Sorting _sorting = Sorting.ByPopularity;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  Future<void> _refreshList() async {
    final List<CommunityChallengeData>? newChallenges = await context
        .read<FirebaseService>()
        .getCommunityChallenges(sortBy: _sorting, limit: 50);

    if (newChallenges != null && mounted) {
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
                child: DropdownButton<Sorting>(
                  isExpanded: true,
                  value: _sorting,
                  items: <DropdownMenuItem<Sorting>>[
                    DropdownMenuItem<Sorting>(
                      child: Text(NyaNyaLocalizations.of(context).dateLabel),
                      value: Sorting.ByDate,
                    ),
                    DropdownMenuItem<Sorting>(
                      child: Text(NyaNyaLocalizations.of(context).nameLabel),
                      value: Sorting.ByName,
                    ),
                    DropdownMenuItem<Sorting>(
                      child:
                          Text(NyaNyaLocalizations.of(context).popularityLabel),
                      value: Sorting.ByPopularity,
                    )
                  ],
                  onChanged: (Sorting? value) {
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
