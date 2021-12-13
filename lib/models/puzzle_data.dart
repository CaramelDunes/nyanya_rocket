import 'dart:convert';

import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class PuzzleData {
  final GameState gameData;
  final List<int> availableArrows;

  PuzzleData({required this.gameData, required this.availableArrows});

  PuzzleData.fromJsonGameData(
      {required String jsonGameData, required List<int> availableArrows})
      : this(
            gameData: GameState.fromJson(jsonDecode(jsonGameData)),
            availableArrows: availableArrows);

  PuzzleData.withBorder()
      : gameData = GameState()..board = Board.withBorder(),
        availableArrows = List.filled(4, 0);

  GameState getGame() => gameData;

  static PuzzleData fromJson(Map<String, dynamic> json) {
    return PuzzleData.fromJsonGameData(
        jsonGameData: json['gameData'],
        availableArrows:
            json['arrows'].map<int>((dynamic value) => value as int).toList());
  }

  Map<String, dynamic> toJson() =>
      {'gameData': jsonEncode(gameData.toJson()), 'arrows': availableArrows};
}
