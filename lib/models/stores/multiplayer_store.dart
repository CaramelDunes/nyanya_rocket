import 'dart:convert';

import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:uuid/uuid.dart';
import 'named_data_store.dart';

abstract class MultiplayerStore {
  static const storeName = 'multiplayer';
  static const Uuid _uuid = Uuid();

  static Future<Map<String, String>> registry() =>
      NamedDataStorage.active.readRegistry(storeName);

  static Future<String?> saveNew(MultiplayerBoard boardData) async {
    final Map<String, String> registry =
        await NamedDataStorage.active.readRegistry(storeName);
    final String uuid =
        _uuid.v4(); // Assume that the registry doesn't contain the new uuid.

    bool dataWritten = await NamedDataStorage.active
        .writeData(storeName, uuid, jsonEncode(boardData.toJson()));

    if (dataWritten) {
      registry[uuid] = boardData.name;
      bool success =
          await NamedDataStorage.active.writeRegistry(storeName, registry);

      if (success) return uuid;
    }
  }

  static Future<bool> update(String uuid, MultiplayerBoard boardData) async {
    return NamedDataStorage.active
        .writeData(storeName, uuid, jsonEncode(boardData.toJson()));
  }

  static Future<MultiplayerBoard?> read(String uuid) async {
    final Map<String, String> registry =
        await NamedDataStorage.active.readRegistry(storeName);
    String? jsonEncoded =
        await NamedDataStorage.active.readData(storeName, uuid);

    if (registry.containsKey(uuid) && jsonEncoded != null) {
      return MultiplayerBoard.fromJson(jsonDecode(jsonEncoded));
    }
  }

  static Future<bool> delete(String uuid) async {
    return NamedDataStorage.active.deleteData(storeName, uuid);
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
