import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/board/static_game_view.dart';
import 'package:nyanya_rocket/widgets/navigation/star_count.dart';
import 'package:provider/provider.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/screens/challenges/community_challenge_data.dart';
import '../../../models/challenge_data.dart';
import '../../../services/firestore/firestore_service.dart';
import '../../../widgets/layout/board_card.dart';
import '../../../widgets/layout/board_list.dart';
import '../../../widgets/navigation/community_filter_bar.dart';

class CommunityChallenges extends StatefulWidget {
  const CommunityChallenges({Key? key}) : super(key: key);

  @override
  State<CommunityChallenges> createState() => _CommunityChallengesState();
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
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshList,
            child: BoardList(
                itemCount: challenges.length,
                tileBuilder: (BuildContext context, int index) {
                  return _buildChallengeTile(challenges[index]);
                },
                cardBuilder: (BuildContext context, int index) =>
                    _buildChallengeCard(challenges[index])),
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

  Widget _buildChallengeTile(CommunityChallengeData challenge) {
    return ListTile(
      title: Text(challenge.name),
      subtitle: Text(
          '${challenge.author}\n${MaterialLocalizations.of(context).formatMediumDate(challenge.date)}'),
      isThreeLine: true,
      trailing: StarCount(count: challenge.likes),
      onTap: () {
        Router.of(context)
            .routerDelegate
            .setNewRoutePath(NyaNyaRoutePath.communityChallenge(challenge.uid));
      },
    );
  }

  Widget _buildChallengeCard(CommunityChallengeData challenge) {
    return BoardCard(
      key: ValueKey(challenge.uid),
      game: challenge.data.getGame(),
      description: [
        Text(
          '${challenge.name} (${challenge.data.type.toLocalizedString(context)})',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(challenge.author),
            StarCount(count: challenge.likes),
          ],
        )
      ],
      onTap: () {
        Router.of(context)
            .routerDelegate
            .setNewRoutePath(NyaNyaRoutePath.communityChallenge(challenge.uid));
      },
    );
  }
}
