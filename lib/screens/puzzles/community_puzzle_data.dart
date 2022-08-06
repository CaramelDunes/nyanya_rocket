import 'package:nyanya_rocket/models/named_puzzle_data.dart';

class CommunityPuzzleData extends NamedPuzzleData {
  final String uid;
  final String author;
  final int likes;
  final DateTime date;

  CommunityPuzzleData({
    required this.uid,
    required super.name,
    required this.author,
    required this.likes,
    required super.puzzleData,
    required this.date,
  });
}
