import 'package:meta/meta.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';

class NamedPuzzleData {
  String name;
  PuzzleData puzzleData;

  NamedPuzzleData(
      {@required this.name,
      @required String gameData,
      @required List<int> availableArrows})
      : puzzleData =
            PuzzleData(gameData: gameData, availableArrows: availableArrows);

  NamedPuzzleData.fromPuzzleData(
      {@required this.name, @required this.puzzleData});

  static NamedPuzzleData fromJson(Map<String, dynamic> json) {
    return NamedPuzzleData.fromPuzzleData(
        name: json['name'], puzzleData: PuzzleData.fromJson(json));
  }

  Map<String, dynamic> toJson() => {'name': name}..addAll(puzzleData.toJson());
}
