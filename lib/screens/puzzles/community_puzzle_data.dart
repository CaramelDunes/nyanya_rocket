import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class CommunityPuzzleData extends PuzzleData {
  final String author;
  final int likes;

  CommunityPuzzleData(
      {this.author,
      this.likes,
      @required String name,
      @required String gameData,
      @required List<int> availableArrows})
      : super(name: name, availableArrows: availableArrows, gameData: gameData);

  Game getGame() => Game.fromJson(jsonDecode(gameData));

  static CommunityPuzzleData fromJson(Map<String, dynamic> json) {
    return CommunityPuzzleData(
        name: json['name'],
        gameData: json['gameData'],
        availableArrows:
            json['arrows'].map<int>((dynamic value) => value as int).toList());
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'gameData': gameData, 'arrows': availableArrows};
}
