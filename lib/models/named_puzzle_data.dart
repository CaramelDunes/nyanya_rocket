import 'package:nyanya_rocket/models/named_data.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';

class NamedPuzzleData extends NamedData<PuzzleData> {
  NamedPuzzleData({required String name, required PuzzleData puzzleData})
      : super(name: name, data: puzzleData);

  NamedPuzzleData.fromGameData(
      {required String name,
      required String gameData,
      required List<int> availableArrows})
      : this(
            name: name,
            puzzleData: PuzzleData.fromJsonGameData(
                jsonGameData: gameData, availableArrows: availableArrows));

  static NamedPuzzleData fromJson(Map<String, dynamic> json) {
    return NamedPuzzleData(
        name: json['name'], puzzleData: PuzzleData.fromJson(json));
  }

  Map<String, dynamic> toJson() => {'name': name}..addAll(data.toJson());
}
