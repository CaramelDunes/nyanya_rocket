import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/star_count.dart';
import 'package:provider/provider.dart';

import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/screens/puzzles/community_puzzle_data.dart';

import '../../../services/firestore/firestore_service.dart';
import '../../../widgets/board_card.dart';
import '../../../widgets/board_list.dart';

class CommunityPuzzles extends StatefulWidget {
  final Future<List<CommunityPuzzleData>?>? puzzles;

  const CommunityPuzzles({Key? key, this.puzzles}) : super(key: key);

  @override
  _CommunityPuzzlesState createState() => _CommunityPuzzlesState();
}

class _CommunityPuzzlesState extends State<CommunityPuzzles>
    with AutomaticKeepAliveClientMixin<CommunityPuzzles> {
  late Future<List<CommunityPuzzleData>?> puzzles;
  Sorting _sorting = Sorting.byPopularity;

  @override
  void initState() {
    super.initState();

    puzzles = widget.puzzles ??
        context
            .read<FirestoreService>()
            .getCommunityPuzzles(sortBy: _sorting, limit: 50);
  }

  Future<void> _refreshList() async {
    setState(() {
      puzzles = context
          .read<FirestoreService>()
          .getCommunityPuzzles(sortBy: _sorting, limit: 50);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<CommunityPuzzleData>?>(
              future: puzzles,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text('An error occured...'));
                }

                final List<CommunityPuzzleData> puzzleList = snapshot.data!;

                return Center(
                  child: RefreshIndicator(
                    onRefresh: _refreshList,
                    child: BoardList(
                      itemCount: puzzleList.length,
                      tileBuilder: (context, i) =>
                          _buildPuzzleTile(puzzleList[i]),
                      cardBuilder: (context, i) =>
                          _buildPuzzleCard(puzzleList[i]),
                    ),
                  ),
                );
              }),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _buildFilters(),
        ),
      ],
    );
  }

  Widget _buildPuzzleTile(CommunityPuzzleData puzzle) {
    return ListTile(
      title: Text(puzzle.name),
      subtitle: Text(
          '${puzzle.author}\n${MaterialLocalizations.of(context).formatMediumDate(puzzle.date)}'),
      isThreeLine: true,
      trailing: StarCount(count: puzzle.likes),
      onTap: () {
        Router.of(context)
            .routerDelegate
            .setNewRoutePath(NyaNyaRoutePath.communityPuzzle(puzzle.uid));
      },
    );
  }

  Widget _buildPuzzleCard(CommunityPuzzleData puzzle) {
    return InkWell(
      key: ValueKey(puzzle.uid),
      child: BoardCard(game: puzzle.puzzleData.getGame(), description: [
        Text(
          puzzle.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text(puzzle.author), StarCount(count: puzzle.likes)],
        )
      ]),
      onTap: () {
        Router.of(context)
            .routerDelegate
            .setNewRoutePath(NyaNyaRoutePath.communityPuzzle(puzzle.uid));
      },
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          NyaNyaLocalizations.of(context).sortByLabel,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        const VerticalDivider(),
        Expanded(
          child: DropdownButton<Sorting>(
            isExpanded: true,
            value: _sorting,
            items: <DropdownMenuItem<Sorting>>[
              DropdownMenuItem<Sorting>(
                child: Text(NyaNyaLocalizations.of(context).dateLabel),
                value: Sorting.byDate,
              ),
              DropdownMenuItem<Sorting>(
                child: Text(NyaNyaLocalizations.of(context).nameLabel),
                value: Sorting.byName,
              ),
              DropdownMenuItem<Sorting>(
                child: Text(NyaNyaLocalizations.of(context).popularityLabel),
                value: Sorting.byPopularity,
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
        IconButton(
            onPressed: _refreshList,
            icon: const Icon(Icons.refresh),
            tooltip: NyaNyaLocalizations.of(context).refreshLabel)
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
