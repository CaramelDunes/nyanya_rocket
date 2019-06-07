import 'dart:convert';

import 'package:nyanya_rocket/models/named_data_store.dart';
import 'package:nyanya_rocket/models/named_puzzle_data.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';

class PuzzleStore extends NamedDataStore {
  PuzzleStore() : super('puzzles');

  Future<String> saveNewPuzzle(NamedPuzzleData puzzleData) async {
    return saveNewData(
        puzzleData.name, jsonEncode(puzzleData.puzzleData.toJson()));
  }

  Future<bool> updatePuzzle(String uuid, NamedPuzzleData puzzleData) async {
    return updateData(uuid, jsonEncode(puzzleData.toJson()));
  }

  Future<NamedPuzzleData> readPuzzle(String uuid) async {
    String jsonEncoded = await readData(uuid);

    return NamedPuzzleData.fromPuzzleData(
        name: entries[uuid],
        puzzleData: PuzzleData.fromJson(jsonDecode(jsonEncoded)));
  }

  Future<bool> deletePuzzle(String uuid) async {
    return deleteData(uuid);
  }
}
