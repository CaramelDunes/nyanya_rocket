import 'package:meta/meta.dart';

class CommunityPuzzleData {
  final String uid;
  final String name;
  final String author;
  final int likes;
  final String puzzleData;
  final DateTime date;

  CommunityPuzzleData({
    @required this.uid,
    @required this.name,
    @required this.author,
    @required this.likes,
    @required this.puzzleData,
    @required this.date,
  });
}
