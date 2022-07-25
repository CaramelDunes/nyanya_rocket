import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/navigation/star_count.dart';
import 'package:provider/provider.dart';

import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/screens/puzzles/community_puzzle_data.dart';

import '../../../services/firestore/firestore_service.dart';
import '../../../widgets/navigation/community_filter_bar.dart';
import '../../../widgets/layout/board_card.dart';
import '../../../widgets/layout/board_list.dart';

class CommunityPuzzles extends StatefulWidget {
  final Future<List<CommunityPuzzleData>?>? puzzles;

  const CommunityPuzzles({Key? key, this.puzzles}) : super(key: key);

  @override
  State<CommunityPuzzles> createState() => _CommunityPuzzlesState();
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
        const Divider(height: 1.0),
        CommunityFilterBar(
          value: _sorting,
          onRefresh: _refreshList,
          onSortingChanged: (Sorting? value) {
            setState(() {
              _sorting = value ?? _sorting;
              _refreshList();
            });
          },
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
      child: BoardCard(game: puzzle.data.getGame(), description: [
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

  @override
  bool get wantKeepAlive => true;
}
