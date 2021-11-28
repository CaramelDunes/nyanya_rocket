import 'package:nyanya_rocket/models/challenge_data.dart';

import 'named_data.dart';

class NamedChallengeData extends NamedData<ChallengeData> {
  NamedChallengeData(
      {required String name, required ChallengeData challengeData})
      : super(name: name, data: challengeData);

  NamedChallengeData.fromGameData(
      {required String name,
      required String gameData,
      required ChallengeType type})
      : this(
            name: name,
            challengeData: ChallengeData(gameData: gameData, type: type));

  factory NamedChallengeData.fromJson(Map<String, dynamic> json) {
    return NamedChallengeData(
        name: json['name'], challengeData: ChallengeData.fromJson(json));
  }

  Map<String, dynamic> toJson() => {'name': name}..addAll(data.toJson());

  ChallengeType get type => data.type;
}
