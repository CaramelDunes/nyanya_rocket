import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class MultiplayerBoard {
  final String name;
  final int maxPlayer;
  final String boardData;

  MultiplayerBoard(
      {@required this.name,
      @required this.maxPlayer,
      @required this.boardData});

  MultiplayerBoard.withBorder({
    @required this.name,
    @required this.maxPlayer,
  }) : boardData = jsonEncode(Board.withBorder().toJson());

  Board board() => Board.fromJson(jsonDecode(boardData));

  static MultiplayerBoard fromJson(Map<String, dynamic> json) {
    return MultiplayerBoard(
        name: json['name'],
        maxPlayer: json['playerCount'],
        boardData: json['boardData']);
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'playerCount': maxPlayer, 'boardData': boardData};
}
