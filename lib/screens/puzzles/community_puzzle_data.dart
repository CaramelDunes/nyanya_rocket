import 'package:nyanya_rocket/models/named_puzzle_data.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';

class CommunityPuzzleData extends NamedPuzzleData {
  final String uid;
  final String author;
  final int likes;
  final DateTime date;

  CommunityPuzzleData({
    required this.uid,
    required String name,
    required this.author,
    required this.likes,
    required PuzzleData puzzleData,
    required this.date,
  }) : super.fromPuzzleData(name: name, puzzleData: puzzleData);
}
