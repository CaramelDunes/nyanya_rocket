import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../models/challenge_data.dart';
import '../../boards/original_challenges.dart';
import '../../models/named_challenge_data.dart';
import '../../routing/nyanya_route_path.dart';
import '../challenges/challenge_progression_manager.dart';
import 'challenge.dart';

class OriginalChallenge extends StatelessWidget {
  final int id;

  const OriginalChallenge({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final challenge = originalChallenges[id];
    final nextChallenge =
        id + 1 < originalChallenges.length ? originalChallenges[id + 1] : null;

    return Challenge(
      challenge: NamedChallengeData(
          challengeData: challenge.data,
          name:
              challenge.data.type.toLocalizedString(context) + challenge.name),
      nextRoutePath: nextChallenge != null
          ? NyaNyaRoutePath.originalChallenge(nextChallenge.originalSlug())
          : null,
      onWin: (time) {
        context.read<ChallengeProgressionManager>().setTime(id, time);
      },
    );
  }
}
