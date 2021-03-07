import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:slugify/slugify.dart';

class NamedChallengeData {
  final String name;
  final ChallengeData challengeData;

  NamedChallengeData(
      {required this.name,
      required String gameData,
      required ChallengeType type})
      : challengeData = ChallengeData(gameData: gameData, type: type);

  NamedChallengeData.fromChallengeData(
      {required this.name, required this.challengeData});

  static NamedChallengeData fromJson(Map<String, dynamic> json) {
    return NamedChallengeData.fromChallengeData(
        name: json['name'], challengeData: ChallengeData.fromJson(json));
  }

  Map<String, dynamic> toJson() =>
      {'name': name}..addAll(challengeData.toJson());

  ChallengeType get type => challengeData.type;

  String get slug => Slugify(type.toPrettyString() + name);
}
