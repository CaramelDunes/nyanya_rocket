import '../../models/challenge_data.dart';
import '../../models/named_challenge_data.dart';

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
  }) : super(name: name, challengeData: challengeData);
}
