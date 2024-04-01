import '../../models/named_challenge_data.dart';

class CommunityChallengeData extends NamedChallengeData {
  final String uid;
  final String author;
  final int likes;
  final DateTime date;

  CommunityChallengeData({
    required this.uid,
    required super.name,
    required this.author,
    required this.likes,
    required super.challengeData,
    required this.date,
  });
}
