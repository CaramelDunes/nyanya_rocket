import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/models/named_challenge_data.dart';

class CommunityChallengeData extends NamedChallengeData {
  final String uid;
  final String author;
  final int likes;
  final DateTime date;

  CommunityChallengeData({
    required this.uid,
    required String name,
    required this.author,
    required this.likes,
    required ChallengeData challengeData,
    required this.date,
  }) : super.fromChallengeData(name: name, challengeData: challengeData);
}
