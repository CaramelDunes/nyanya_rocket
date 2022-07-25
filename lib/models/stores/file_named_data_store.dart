import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:path_provider/path_provider.dart';
import 'named_data_store.dart';

class FileNamedDataStorage implements NamedDataStorage {
  @override
  Future<Map<String, String>> readRegistry(String storeName) async {
    File registryFile = File(await _registryFilePath(storeName));

    if (!await registryFile.exists()) {
      await registryFile.create(recursive: true);
      return {};
    }

    String contents = await registryFile.readAsString();

    Map<String, String> entries = {};

    for (String entry in contents.split('\n')) {
      int separator = entry.indexOf(';');

      if (separator == -1) {
        if (entry.isNotEmpty) {
          print('Ignoring invalid entry: $entry');
        }
        continue;
      }

      entries[entry.substring(0, separator)] = entry.substring(separator + 1);
    }

    return entries;
  }

  @override
  Future<bool> writeRegistry(
      String storeName, Map<String, String> registry) async {
    String stringValue = '';

    registry.forEach((String id, String name) => stringValue += '$id;$name\n');

    File registryFile = File(await _registryFilePath(storeName));

    if (!await registryFile.exists()) {
      await registryFile.create(recursive: true);

      if (!await registryFile.exists()) {
        return false;
      }
    }

    await registryFile.writeAsString(stringValue, flush: true);
    return true;
  }

  @override
  Future<String?> readData(String storeName, String dataId) async {
    File dataFile = File(await _dataFilePath(storeName, dataId));

    if (await dataFile.exists()) {
      return dataFile.readAsString();
    }
    return null;
  }

  @override
  Future<bool> deleteData(String storeName, String dataId) async {
    // TODO Handle exception.
    await File(await _dataFilePath(storeName, dataId)).delete();
    return true;
  }

  @override
  Future<bool> writeData(String storeName, String dataId, String data) async {
    File dataFile = File(await _dataFilePath(storeName, dataId));

    if (!await dataFile.exists()) {
      await dataFile.create(recursive: true);

      if (!await dataFile.exists()) {
        return false;
      }
    }

    await dataFile.writeAsString(data);
    return true;
  }

  static Future<String> _registryFilePath(String storeName) async {
    Directory directory = await getApplicationSupportDirectory();
    return p.join(directory.path, storeName, 'registry.txt');
  }

  static Future<String> _dataFilePath(String storeName, String dataId) async {
    Directory directory = await getApplicationSupportDirectory();
    return p.join(directory.path, storeName, '$dataId.txt');
  }
}
