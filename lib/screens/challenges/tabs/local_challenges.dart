import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/named_challenge_data.dart';
import 'package:nyanya_rocket/models/user.dart';
import 'package:nyanya_rocket/screens/challenge/challenge.dart';
import 'package:nyanya_rocket/widgets/empty_list.dart';
import 'package:nyanya_rocket/widgets/success_overlay.dart';
import 'package:provider/provider.dart';

import '../../../models/stores/challenge_store.dart';

class LocalChallenges extends StatefulWidget {
  @override
  _LocalChallengesState createState() => _LocalChallengesState();
}

class _LocalChallengesState extends State<LocalChallenges> {
  Map<String, String> _challenges = Map();

  @override
  void initState() {
    super.initState();

    ChallengeStore.registry()
        .then((Map<String, String> entries) => setState(() {
              _challenges = entries;
            }));
  }

  void _verifyAndPublish(BuildContext context, NamedChallengeData challenge) {
    Navigator.push<OverlayResult>(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Challenge(
                  challenge: challenge,
                  hasNext: false,
                ))).then((OverlayResult? overlayResult) {
      if (overlayResult != null) {
        FirebaseFunctions.instance.httpsCallable('publishChallenge').call({
          'name': challenge.name,
          'challenge_data': jsonEncode(challenge.challengeData.toJson()),
        }).then((HttpsCallableResult result) {
          print(result.data);
        });

        final snackBar = SnackBar(
            content: Text(NyaNyaLocalizations.of(context).publishSuccessText));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(
            content: Text(
                NyaNyaLocalizations.of(context).puzzleNotCompletedLocallyText));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);

    List<String> uuidList = _challenges.keys.toList().reversed.toList();

    if (uuidList.isEmpty) {
      return Center(child: EmptyList());
    }

    return ListView.separated(
        separatorBuilder: (context, int) => Divider(),
        itemCount: _challenges.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(_challenges[uuidList[i]]!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
//                  IconButton(
//                    icon: Icon(Icons.share),
//                    onPressed: () {
//                      Share.share(
//                          'Check out this new puzzle I made! nyanya://puzzle/superjsonbase64');
//                    },
//                  ),
                  IconButton(
                    icon: Icon(Icons.publish),
                    tooltip: NyaNyaLocalizations.of(context).publishLabel,
                    onPressed: () {
                      if (user.isConnected) {
                        ChallengeStore.readChallenge(uuidList[i])
                            .then((NamedChallengeData? puzzle) {
                          if (puzzle != null)
                            _verifyAndPublish(context, puzzle);
                          else
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Couldn\'t read puzzle data.')));
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
                ChallengeStore.readChallenge(uuidList[i])
                    .then((NamedChallengeData? challenge) {
                  if (challenge != null)
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Challenge(
                              challenge: challenge,
                              hasNext: i != _challenges.length - 1,
                            )));
                  else
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Couldn\'t read challenge data.')));
                });
              },
            ));
  }
}
