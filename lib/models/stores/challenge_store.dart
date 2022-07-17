import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../named_challenge_data.dart';
import '../challenge_data.dart';
import 'named_data_store.dart';

abstract class ChallengeStore {
  static const storeName = 'challenges';
  static const Uuid _uuid = Uuid();

  static Future<Map<String, String>> registry() =>
      NamedDataStorage.active.readRegistry(storeName);

  static Future<String?> saveNew(NamedChallengeData challengeData) async {
    final Map<String, String> registry =
        await NamedDataStorage.active.readRegistry(storeName);
    final String uuid =
        _uuid.v4(); // Assume that the registry doesn't contain the new uuid.

    bool dataWritten = await NamedDataStorage.active
        .writeData(storeName, uuid, jsonEncode(challengeData.toJson()));

    if (dataWritten) {
      registry[uuid] = challengeData.name;
      bool success =
          await NamedDataStorage.active.writeRegistry(storeName, registry);

      if (success) return uuid;
    }
    return null;
  }

  static Future<bool> update(
      String uuid, NamedChallengeData challengeData) async {
    return NamedDataStorage.active
        .writeData(storeName, uuid, jsonEncode(challengeData.toJson()));
  }

  static Future<NamedChallengeData?> read(String uuid) async {
    final Map<String, String> registry =
        await NamedDataStorage.active.readRegistry(storeName);
    String? jsonEncoded =
        await NamedDataStorage.active.readData(storeName, uuid);

    if (registry.containsKey(uuid) && jsonEncoded != null) {
      return NamedChallengeData(
          name: registry[uuid]!,
          challengeData: ChallengeData.fromJson(jsonDecode(jsonEncoded)));
    }
    return null;
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
