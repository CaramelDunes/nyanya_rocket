import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../models/challenge_data.dart';
import '../../models/named_challenge_data.dart';
import '../../routing/nyanya_route_path.dart';
import '../challenges/challenge_progression_manager.dart';
import '../challenges/tabs/original_challenges.dart';
import 'challenge.dart';

class OriginalChallenge extends StatelessWidget {
  final int id;

  const OriginalChallenge({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Challenge(
      challenge: NamedChallengeData(
          challengeData: OriginalChallenges.challenges[id].data,
          name: OriginalChallenges.challenges[id].data.type
                  .toLocalizedString(context) +
              OriginalChallenges.challenges[id].name),
      nextRoutePath: id + 1 < OriginalChallenges.challenges.length
          ? NyaNyaRoutePath.originalChallenge(OriginalChallenges.originalSlug(
              OriginalChallenges.challenges[id + 1]))
          : null,
      onWin: (time) {
        context.read<ChallengeProgressionManager>().setTime(id, time);
      },
    );
  }
}
