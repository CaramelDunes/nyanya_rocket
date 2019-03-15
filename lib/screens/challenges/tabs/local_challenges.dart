import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/models/challenge_store.dart';
import 'package:nyanya_rocket/screens/challenge/challenge.dart';
import 'package:nyanya_rocket/widgets/empty_list.dart';

class LocalChallenges extends StatefulWidget {
  static final ChallengeStore store = ChallengeStore();

  @override
  _LocalChallengesState createState() {
    return _LocalChallengesState();
  }
}

class _LocalChallengesState extends State<LocalChallenges> {
  HashMap<String, String> _challenges = HashMap();

  @override
  void initState() {
    super.initState();

    LocalChallenges.store.readRegistry().then((HashMap entries) => setState(() {
          _challenges = entries;
        }));
  }

  @override
  Widget build(BuildContext context) {
    List<String> uuidList = _challenges.keys.toList();

    if (uuidList.isEmpty) {
      return Center(child: EmptyList());
    }

    return ListView.separated(
        separatorBuilder: (context, int) => Divider(),
        itemCount: _challenges.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(_challenges[uuidList[i]]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
              ),
              onTap: () {
                LocalChallenges.store.readChallenge(uuidList[i]).then(
                    (ChallengeData challenge) =>
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Challenge(
                                  challenge: challenge,
                                ))));
              },
            ));
  }
}
