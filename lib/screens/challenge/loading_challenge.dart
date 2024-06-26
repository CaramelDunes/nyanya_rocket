import 'package:flutter/material.dart';

import 'package:nyanya_rocket/screens/challenges/community_challenge_data.dart';
import '../../localization/nyanya_localizations.dart';
import 'challenge.dart';

class LoadingChallenge extends StatelessWidget {
  final Future<CommunityChallengeData> futureChallenge;

  const LoadingChallenge({super.key, required this.futureChallenge});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CommunityChallengeData>(
        future: futureChallenge,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Scaffold(
                appBar: AppBar(
                  title: Text(NyaNyaLocalizations.of(context).challengesTitle),
                ),
                body: Center(
                  child: Text(
                    NyaNyaLocalizations.of(context).loadingLabel,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              );

            case ConnectionState.active:
            case ConnectionState.done:
              if (!snapshot.hasError) {
                return Challenge(
                    challenge: snapshot.data!,
                    documentPath: 'challenges/${snapshot.data!.uid}');
              } else {
                return Scaffold(
                  appBar: AppBar(
                    title:
                        Text(NyaNyaLocalizations.of(context).challengesTitle),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          NyaNyaLocalizations.of(context)
                              .couldNotLoadChallengeText,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        FilledButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(MaterialLocalizations.of(context)
                                .backButtonTooltip))
                      ],
                    ),
                  ),
                );
              }
          }
        });
  }
}
