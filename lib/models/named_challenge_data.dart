import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:slugify/slugify.dart';

class NamedChallengeData {
  final String name;
  final ChallengeData challengeData;
  final String slug;

  NamedChallengeData({required this.name, required this.challengeData})
      : slug = slugify(challengeData.type.toPrettyString() + name);

  factory NamedChallengeData.fromGameData(
      {required String name,
      required String gameData,
      required ChallengeType type}) {
    return NamedChallengeData(
        name: name,
        challengeData: ChallengeData(gameData: gameData, type: type));
  }

  factory NamedChallengeData.fromJson(Map<String, dynamic> json) {
    return NamedChallengeData(
        name: json['name'], challengeData: ChallengeData.fromJson(json));
  }

  Map<String, dynamic> toJson() =>
      {'name': name}..addAll(challengeData.toJson());

  ChallengeType get type => challengeData.type;
}
