import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/static_game_view.dart';
import 'package:nyanya_rocket/widgets/star_count.dart';
import 'package:provider/provider.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/screens/challenges/community_challenge_data.dart';
import '../../../models/challenge_data.dart';
import '../../../services/firestore/firestore_service.dart';
import '../../../widgets/community_filter_bar.dart';

class CommunityChallenges extends StatefulWidget {
  const CommunityChallenges({Key? key}) : super(key: key);

  @override
  _CommunityChallengesState createState() => _CommunityChallengesState();
}

class _CommunityChallengesState extends State<CommunityChallenges> {
  List<CommunityChallengeData> challenges = [];
  Sorting _sorting = Sorting.byPopularity;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  Future<void> _refreshList() async {
    final List<CommunityChallengeData>? newChallenges = await context
        .read<FirestoreService>()
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
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshList,
            child: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                if (orientation == Orientation.landscape ||
                    MediaQuery.of(context).size.width >= 270 * 2.5) {
                  return _buildLandscape();
                } else {
                  return _buildPortrait();
                }
              },
            ),
          ),
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

  Widget _buildPortrait() {
    return ListView.builder(
        itemCount: challenges.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(challenges[i].name),
              subtitle: Text(
                  '${challenges[i].author}\n${MaterialLocalizations.of(context).formatMediumDate(challenges[i].date)}'),
              isThreeLine: true,
              trailing: StarCount(count: challenges[i].likes),
              onTap: () {
                Router.of(context).routerDelegate.setNewRoutePath(
                    NyaNyaRoutePath.communityChallenge(challenges[i].uid));
              },
            ));
  }

  Widget _buildLandscape() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 270,
        ),
        itemCount: challenges.length,
        itemBuilder: (context, i) => _buildChallengeCard(i));
  }

  Widget _buildChallengeCard(int i) {
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
                    game: challenges[i].challengeData.getGame(),
                  ),
                )),
            Text(
              '${challenges[i].name} (${challenges[i].challengeData.type.toLocalizedString(context)})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(challenges[i].author),
                StarCount(count: challenges[i].likes),
              ],
            )
          ],
        ),
      ),
      onTap: () {
        Router.of(context).routerDelegate.setNewRoutePath(
            NyaNyaRoutePath.communityChallenge(challenges[i].uid));
      },
    );
  }
}
