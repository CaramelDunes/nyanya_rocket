import 'dart:convert';

import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/models/named_challenge_data.dart';
import 'package:nyanya_rocket/models/named_data_store.dart';

class ChallengeStore extends NamedDataStore {
  ChallengeStore() : super('challenges');

  Future<String> saveNewChallenge(NamedChallengeData challengeData) async {
    return saveNewData(challengeData.name, jsonEncode(challengeData.toJson()));
  }

  Future<bool> updateChallenge(
      String uuid, NamedChallengeData challengeData) async {
    return updateData(uuid, jsonEncode(challengeData.challengeData.toJson()));
  }

  Future<NamedChallengeData> readChallenge(String uuid) async {
    String jsonEncoded = await readData(uuid);

    return NamedChallengeData.fromChallengeData(
        name: entries[uuid],
        challengeData: ChallengeData.fromJson(jsonDecode(jsonEncoded)));
  }

  Future<bool> deleteChallenge(String uuid) async {
    return deleteData(uuid);
  }
}
