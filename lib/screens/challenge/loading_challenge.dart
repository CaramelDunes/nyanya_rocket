import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../localization/nyanya_localizations.dart';
import '../../models/challenge_data.dart';
import '../../models/named_challenge_data.dart';
import 'challenge.dart';

class LoadingChallenge extends StatelessWidget {
  final Future<NamedChallengeData> futureChallenge;

  factory LoadingChallenge.fromChallengeId(String challengeId) {
    final futureChallenge = FirebaseFirestore.instance
        .doc('/challenges/$challengeId')
        .get()
        .then((snapshot) => NamedChallengeData.fromChallengeData(
            name: snapshot.get('name'),
            challengeData: ChallengeData.fromJson(
                jsonDecode(snapshot.get('challenge_data')))));

    return LoadingChallenge(futureChallenge: futureChallenge);
  }

  LoadingChallenge({Key? key, required this.futureChallenge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NamedChallengeData>(
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
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              );

            case ConnectionState.active:
            case ConnectionState.done:
              if (!snapshot.hasError) {
                return Challenge(
                  challenge: snapshot.data!,
                );
              } else {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(NyaNyaLocalizations.of(context).challengesTitle),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          NyaNyaLocalizations.of(context)
                              .couldNotLoadChallengeText,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(NyaNyaLocalizations.of(context).back))
                      ],
                    ),
                  ),
                );
              }
          }
        });
  }
}
