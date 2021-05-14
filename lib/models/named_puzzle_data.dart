import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:slugify/slugify.dart';

class NamedPuzzleData {
  final String name;
  final PuzzleData puzzleData;

  NamedPuzzleData(
      {required this.name,
      required String gameData,
      required List<int> availableArrows})
      : puzzleData =
            PuzzleData(gameData: gameData, availableArrows: availableArrows);

  NamedPuzzleData.fromPuzzleData(
      {required this.name, required this.puzzleData});

  static NamedPuzzleData fromJson(Map<String, dynamic> json) {
    return NamedPuzzleData.fromPuzzleData(
        name: json['name'], puzzleData: PuzzleData.fromJson(json));
  }

  Map<String, dynamic> toJson() => {'name': name}..addAll(puzzleData.toJson());

  String get slug => slugify(name);
}
