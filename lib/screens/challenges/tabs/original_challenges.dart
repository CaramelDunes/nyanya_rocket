import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../boards/original_challenges.dart';
import '../../../models/challenge_data.dart';
import '../../../models/named_challenge_data.dart';
import '../../../routing/nyanya_route_path.dart';
import '../../../widgets/layout/board_card.dart';
import '../../../widgets/layout/board_list.dart';
import '../../../widgets/navigation/completion_indicator.dart';
import '../challenge_progression_manager.dart';

class OriginalChallenges extends StatefulWidget {
  const OriginalChallenges({super.key});

  @override
  State<OriginalChallenges> createState() => _OriginalChallengesState();
}

class _OriginalChallengesState extends State<OriginalChallenges> {
  bool _showCompleted = true;

  void _openChallenge(String slug) {
    Router.of(context)
        .routerDelegate
        .setNewRoutePath(NyaNyaRoutePath.originalChallenge(slug));
  }

  @override
  Widget build(BuildContext context) {
    List<int> challengeIndices =
        Iterable<int>.generate(originalChallenges.length)
            .toList(growable: false);

    final progression = context.watch<ChallengeProgressionManager>();
    final times = progression.getTimes();
    final cleared = times.keys.toSet();

    if (!_showCompleted) {
      challengeIndices = SplayTreeSet<int>.from(challengeIndices)
          .difference(cleared)
          .toList(growable: false);
    }

    return Column(
      children: [
        Expanded(
          child: BoardList(
              itemCount: challengeIndices.length,
              tileBuilder: (BuildContext context, int index) {
                return _buildChallengeTile(
                    originalChallenges[challengeIndices[index]], times[index]);
              },
              cardBuilder: (BuildContext context, int index) =>
                  _buildChallengeCard(
                      originalChallenges[challengeIndices[index]],
                      times[index])),
        ),
        CompletionIndicator(
          completedRatio: cleared.length / originalChallenges.length,
          showCompleted: _showCompleted,
          onChanged: (bool? value) {
            if (value != null) {
              setState(() {
                _showCompleted = value;
              });
            }
          },
        )
      ],
    );
  }

  Widget _buildChallengeTile(
      NamedChallengeData namedChallengeData, Duration? time) {
    final bool isCleared = time != null;

    return ListTile(
      title: Text(namedChallengeData.fullLocalizedName(context)),
      subtitle: Text(namedChallengeData.data.type.toLocalizedString(context)),
      trailing: isCleared
          ? Row(mainAxisSize: MainAxisSize.min, children: [
              Text(_formatTime(time)),
              const Icon(
                Icons.check,
                color: Colors.green,
              )
            ])
          : null,
      onTap: () {
        _openChallenge(namedChallengeData.originalSlug());
      },
    );
  }

  Widget _buildChallengeCard(
      NamedChallengeData namedChallengeData, Duration? time) {
    final bool isCleared = time != null;

    return BoardCard(
      key: ValueKey(namedChallengeData.slug),
      game: namedChallengeData.data.getGame(),
      description: [
        Text(
          namedChallengeData.fullLocalizedName(context),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(isCleared ? _formatTime(time) : '')
      ],
      cleared: isCleared,
      onTap: () {
        _openChallenge(namedChallengeData.originalSlug());
      },
    );
  }

  String _formatTime(Duration time) {
    final String seconds = time.inSeconds.toString();
    final String decimals =
        (time.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0');
    return '$seconds.${decimals}s';
  }
}
