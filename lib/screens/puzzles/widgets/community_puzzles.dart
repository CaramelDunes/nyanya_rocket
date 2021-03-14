import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/static_game_view.dart';
import 'package:nyanya_rocket/widgets/star_count.dart';
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
            child: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                if (orientation == Orientation.landscape ||
                    MediaQuery.of(context).size.width >= 270 * 2.5)
                  return _buildLandscape();
                else
                  return _buildPortrait();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortrait() {
    return ListView.separated(
        separatorBuilder: (context, int) => Divider(),
        itemCount: puzzles.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(puzzles[i].name),
              subtitle: Text(
                  '${puzzles[i].author}\n${MaterialLocalizations.of(context).formatMediumDate(puzzles[i].date)}'),
              isThreeLine: true,
              trailing: StarCount(count: puzzles[i].likes),
              onTap: () {
                Router.of(context).routerDelegate.setNewRoutePath(
                    NyaNyaRoutePath.communityPuzzle(puzzles[i].uid));
              },
            ));
  }

  Widget _buildLandscape() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 270,
        ),
        itemCount: puzzles.length,
        itemBuilder: (context, i) => _buildPuzzleCard(i));
  }

  Widget _buildPuzzleCard(int i) {
    return InkWell(
      key: ValueKey(i),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AspectRatio(
                  aspectRatio: 12 / 9,
                  child: StaticGameView(
                    game: puzzles[i].puzzleData.getGame(),
                  ),
                )),
            Text(
              puzzles[i].name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(puzzles[i].author),
                StarCount(count: puzzles[i].likes)
              ],
            )
          ],
        ),
      ),
      onTap: () {
        Router.of(context)
            .routerDelegate
            .setNewRoutePath(NyaNyaRoutePath.communityPuzzle(puzzles[i].uid));
      },
    );
  }
}
