import 'package:shared_preferences/shared_preferences.dart';

import 'named_data_store.dart';

class PrefsDataStore implements NamedDataStorage {
  final SharedPreferences sharedPreferences;

  String _registryKey(String storeName) {
    return 'named_store_$storeName.registry';
  }

  String _dataKey(String storeName, String dataId) {
    return 'named_store_$storeName.data.$dataId';
  }

  PrefsDataStore(this.sharedPreferences);

  @override
  Future<Map<String, String>> readRegistry(String storeName) async {
    List<String> contents =
        sharedPreferences.getStringList(_registryKey(storeName)) ?? [];

    Map<String, String> registry = {};

    for (String entry in contents) {
      int separator = entry.indexOf(';');

      if (separator == -1) {
        if (entry.isNotEmpty) {
          print('Ignoring invalid entry: $entry');
        }
        continue;
      }

      registry[entry.substring(0, separator)] = entry.substring(separator + 1);
    }

    return registry;
  }

  @override
  Future<bool> writeRegistry(
      String storeName, Map<String, String> registry) async {
    return sharedPreferences.setStringList(
        _registryKey(storeName),
        registry.entries
            .map((entry) => '${entry.key};${entry.value}')
            .toList());
  }

  @override
  Future<bool> writeData(String storeName, String dataId, String data) async {
    return sharedPreferences.setString(_dataKey(storeName, dataId), data);
  }

  @override
  Future<String?> readData(String storeName, String dataId) async {
    return sharedPreferences.getString(_dataKey(storeName, dataId));
  }

  @override
  Future<bool> deleteData(String storeName, String dataId) async {
    return sharedPreferences.remove(_dataKey(storeName, dataId));
  }
}
