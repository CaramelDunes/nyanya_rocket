import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class PuzzleData {
  final String gameData;
  final List<int> availableArrows;

  PuzzleData({@required this.gameData, @required this.availableArrows});

  PuzzleData.withBorder()
      : gameData = jsonEncode((Game()..board = Board.withBorder()).toJson()),
        availableArrows = List.filled(4, 0);

  Game getGame() => Game.fromJson(jsonDecode(gameData));

  static PuzzleData fromJson(Map<String, dynamic> json) {
    return PuzzleData(
        gameData: json['gameData'],
        availableArrows:
            json['arrows'].map<int>((dynamic value) => value as int).toList());
  }

  Map<String, dynamic> toJson() =>
      {'gameData': gameData, 'arrows': availableArrows};
}
