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

  const OriginalChallenge({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Challenge(
      challenge: NamedChallengeData(
          challengeData: OriginalChallenges.challenges[id].challengeData,
          name: OriginalChallenges.challenges[id].challengeData.type
                  .toLocalizedString(context) +
              OriginalChallenges.challenges[id].name),
      nextRoutePath: id + 1 < OriginalChallenges.challenges.length
          ? NyaNyaRoutePath.originalChallenge(
              OriginalChallenges.challenges[id + 1].slug)
          : null,
      onWin: (time) {
        context.read<ChallengeProgressionManager>().setTime(id, time);
      },
    );
  }
}
