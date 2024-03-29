import 'package:flutter/material.dart';

import '../../../config.dart';
import '../../../localization/nyanya_localizations.dart';

class Challenge extends StatelessWidget {
  const Challenge({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kMaxWidthForBigScreens),
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            Text(
              NyaNyaLocalizations.of(context).generalLabel,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text(NyaNyaLocalizations.of(context).challengeTutorialText),
            ),
            Text(
                '${NyaNyaLocalizations.of(context).challengeGetMiceType} / ${NyaNyaLocalizations.of(context).challengeRunAwayType}',
                style: Theme.of(context).textTheme.headlineSmall),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(NyaNyaLocalizations.of(context).challengeGetMiceText),
            ),
            Text(NyaNyaLocalizations.of(context).challengeLunchTimeType,
                style: Theme.of(context).textTheme.headlineSmall),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text(NyaNyaLocalizations.of(context).challengeLunchTimeText),
            ),
            Text(NyaNyaLocalizations.of(context).challengeOneHundredMiceType,
                style: Theme.of(context).textTheme.headlineSmall),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  NyaNyaLocalizations.of(context).challengeOneHundredMiceText),
            ),
          ],
        ),
      ),
    );
  }
}
