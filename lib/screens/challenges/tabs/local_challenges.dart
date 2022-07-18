import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/named_challenge_data.dart';
import 'package:nyanya_rocket/models/user.dart';
import 'package:nyanya_rocket/screens/challenge/challenge.dart';
import 'package:nyanya_rocket/widgets/layout/empty_list.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../config.dart';
import '../../../models/stores/challenge_store.dart';

class LocalChallenges extends StatefulWidget {
  const LocalChallenges({Key? key}) : super(key: key);

  @override
  State<LocalChallenges> createState() => _LocalChallengesState();
}

class _LocalChallengesState extends State<LocalChallenges> {
  Map<String, String> _challenges = {};

  @override
  void initState() {
    super.initState();

    ChallengeStore.registry()
        .then((Map<String, String> entries) => setState(() {
              _challenges = entries;
            }));
  }

  void _verifyAndPublish(BuildContext context, NamedChallengeData challenge) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Challenge(
                  challenge: challenge,
                  onWin: (Duration time) {
                    // FirebaseFunctions.instance
                    //     .httpsCallable('publishChallenge')
                    //     .call({
                    //   'name': challenge.name,
                    //   'challenge_data':
                    //       jsonEncode(challenge.challengeData.toJson()),
                    // }).then((HttpsCallableResult result) {
                    //   print(result.data);
                    // });

                    context
                        .read<User>()
                        .idToken()
                        .then((idToken) => http.post(
                            Uri.https(kCloudFunctionsHost, '/publishChallenge'),
                            headers: {
                              'Authorization': 'Bearer $idToken',
                              'Content-Type': 'application/json'
                            },
                            body: jsonEncode({
                              'data': {
                                'name': challenge.name,
                                'challenge_data':
                                    jsonEncode(challenge.data.toJson()),
                              }
                            })))
                        .then((response) => response.statusCode == 200)
                        .then((success) {
                      if (success) {
                        final snackBar = SnackBar(
                            content: Text(NyaNyaLocalizations.of(context)
                                .publishSuccessText));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    });
                    // } else {
                    //   final snackBar = SnackBar(
                    //       content: Text(
                    //           NyaNyaLocalizations.of(context).puzzleNotCompletedLocallyText));
                    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // }
                  },
                ))).then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);

    List<String> uuidList = _challenges.keys.toList().reversed.toList();

    if (uuidList.isEmpty) {
      return const Center(child: EmptyList());
    }

    return ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _challenges.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(_challenges[uuidList[i]]!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
//                  IconButton(
//                    icon: Icon(Icons.share),
//                    onPressed: () {
//                      Share.share(
//                          'Check out this new puzzle I made! nyanya://puzzle/superjsonbase64');
//                    },
//                  ),
                  IconButton(
                    icon: const Icon(Icons.publish),
                    tooltip: NyaNyaLocalizations.of(context).publishLabel,
                    onPressed: () {
                      if (user.isConnected) {
                        ChallengeStore.read(uuidList[i])
                            .then((NamedChallengeData? puzzle) {
                          if (puzzle != null) {
                            _verifyAndPublish(context, puzzle);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Couldn\'t read puzzle data.')));
                          }
                        });
                      } else {
                        final snackBar = SnackBar(
                            content: Text(NyaNyaLocalizations.of(context)
                                .loginPromptText));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                ],
              ),
              onTap: () {
                ChallengeStore.read(uuidList[i])
                    .then((NamedChallengeData? challenge) {
                  if (challenge != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Challenge(
                              challenge: challenge,
                              // hasNext: i != _challenges.length - 1, TODO
                            )));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Couldn\'t read challenge data.')));
                  }
                });
              },
            ));
  }
}
