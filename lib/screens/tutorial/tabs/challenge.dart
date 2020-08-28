import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';

class Challenge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        Text(
          NyaNyaLocalizations.of(context).generalLabel,
          style: Theme.of(context).textTheme.headline5,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(NyaNyaLocalizations.of(context).challengeTutorialText),
        ),
        Text(
            '${NyaNyaLocalizations.of(context).challengeGetMiceType} / ${NyaNyaLocalizations.of(context).challengeRunAwayType}',
            style: Theme.of(context).textTheme.headline5),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(NyaNyaLocalizations.of(context).challengeGetMiceText),
        ),
        Text(NyaNyaLocalizations.of(context).challengeLunchTimeType,
            style: Theme.of(context).textTheme.headline5),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(NyaNyaLocalizations.of(context).challengeLunchTimeText),
        ),
        Text(NyaNyaLocalizations.of(context).challengeOneHundredMiceType,
            style: Theme.of(context).textTheme.headline5),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Text(NyaNyaLocalizations.of(context).challengeOneHundredMiceText),
        ),
      ],
    );
  }
}
