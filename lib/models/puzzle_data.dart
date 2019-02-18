import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class PuzzleData {
  final String name;
  final String gameData;
  final List<int> availableArrows;

  PuzzleData(
      {@required this.name,
      @required this.gameData,
      @required this.availableArrows});

  PuzzleData.withBorder({@required this.name})
      : gameData = jsonEncode((Game()..board = Board.withBorder()).toJson()),
        availableArrows = List.filled(4, 0);

  Game getGame() => Game.fromJson(jsonDecode(gameData));

  static PuzzleData fromJson(Map<String, dynamic> json) {
    return PuzzleData(
        name: json['name'],
        gameData: json['gameData'],
        availableArrows:
            json['arrows'].map<int>((dynamic value) => value as int).toList());
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'gameData': gameData, 'arrows': availableArrows};
}
