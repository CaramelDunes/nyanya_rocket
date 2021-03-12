import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/screens/puzzles/community_puzzle_data.dart';
import 'package:nyanya_rocket/services/firebase/firebase_service.dart';

class CommunityPuzzles extends StatefulWidget {
  @override
  _CommunityPuzzlesState createState() => _CommunityPuzzlesState();
}

class _CommunityPuzzlesState extends State<CommunityPuzzles> {
  List<CommunityPuzzleData> puzzles = [];
  Sorting _sorting = Sorting.ByPopularity;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  Future<void> _refreshList() async {
    final List<CommunityPuzzleData>? newPuzzles = await context
        .read<FirebaseService>()
        .getCommunityPuzzles(sortBy: _sorting, limit: 50);

    if (newPuzzles != null && mounted) {
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
