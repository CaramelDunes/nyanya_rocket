import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../named_puzzle_data.dart';
import '../puzzle_data.dart';
import 'named_data_store.dart';

abstract class PuzzleStore {
  static const storeName = 'puzzles';
  static const Uuid _uuid = Uuid();

  static Future<Map<String, String>> registry() =>
      NamedDataStorage.active.readRegistry(storeName);

  static Future<String?> saveNewPuzzle(NamedPuzzleData puzzleData) async {
    final Map<String, String> registry =
        await NamedDataStorage.active.readRegistry(storeName);
    final String uuid =
        _uuid.v4(); // Assume that the registry doesn't contain the new uuid.

    bool dataWritten = await NamedDataStorage.active
        .writeData(storeName, uuid, jsonEncode(puzzleData.data.toJson()));

    if (dataWritten) {
      registry[uuid] = puzzleData.name;
      bool success =
          await NamedDataStorage.active.writeRegistry(storeName, registry);

      if (success) return uuid;
    }
  }

  static Future<bool> updatePuzzle(String uuid, PuzzleData puzzleData) async {
    return NamedDataStorage.active
        .writeData(storeName, uuid, jsonEncode(puzzleData.toJson()));
  }

  static Future<NamedPuzzleData?> readPuzzle(String uuid) async {
    final Map<String, String> registry =
        await NamedDataStorage.active.readRegistry(storeName);
    String? jsonEncoded =
        await NamedDataStorage.active.readData(storeName, uuid);

    if (registry.containsKey(uuid) && jsonEncoded != null) {
      return NamedPuzzleData(
          name: registry[uuid]!,
          puzzleData: PuzzleData.fromJson(jsonDecode(jsonEncoded)));
    }
  }

  static Future<bool> deletePuzzle(String uuid) async {
    final Map<String, String> registry =
        await NamedDataStorage.active.readRegistry(storeName);

    if (registry.remove(uuid) != null &&
        await NamedDataStorage.active.writeRegistry(storeName, registry)) {
      await NamedDataStorage.active.deleteData(storeName, uuid);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> rename(String uuid, String name) async {
    final Map<String, String> registry =
        await NamedDataStorage.active.readRegistry(storeName);

    if (registry.containsKey(uuid)) {
      registry[uuid] = name;
      return NamedDataStorage.active.writeRegistry(storeName, registry);
    }

    return false;
  }
}
