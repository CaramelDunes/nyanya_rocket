import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class MultiplayerBoard {
  final String name;
  final int playerCount;
  final String boardData;

  MultiplayerBoard(
      {@required this.name,
      @required this.playerCount,
      @required this.boardData});

  Board board() => Board.fromJson(jsonDecode(boardData));

  static MultiplayerBoard fromJson(Map<String, dynamic> json) {
    return MultiplayerBoard(
        name: json['name'],
        playerCount: json['playerCount'],
        boardData: json['boardData']);
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'playerCount': playerCount, 'boardData': boardData};
}
