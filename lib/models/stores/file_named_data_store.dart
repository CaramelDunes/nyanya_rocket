import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'named_data_store.dart';

class FileNamedDataStorage implements NamedDataStorage {
  Future<Map<String, String>> readRegistry(String registry) async {
    Directory directory = await getApplicationSupportDirectory();

    File _registryFile = File('${directory.path}/$registry/registry.txt');

    if (!await _registryFile.exists()) {
      await _registryFile.create(recursive: true);
      return {};
    }

    String contents = await _registryFile.readAsString();

    Map<String, String> entries = Map();

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

  Future<bool> writeRegistry(
      String storeName, Map<String, String> registry) async {
    String stringValue = '';

    registry.forEach((String id, String name) => stringValue += '$id;$name\n');

    Directory directory = await getApplicationDocumentsDirectory();

    File _registryFile = File('${directory.path}/$storeName/registry.txt');

    if (!await _registryFile.exists()) {
      await _registryFile.create(recursive: true);

      if (!await _registryFile.exists()) {
        return false;
      }
    }

    await _registryFile.writeAsString(stringValue);
    return true;
  }

  Future<String?> readData(String storeName, String uuid) async {
    Directory? directory = await getApplicationDocumentsDirectory();

    File dataFile = File('${directory.path}/$storeName/$uuid.txt');

    if (await dataFile.exists()) {
      return dataFile.readAsString();
    }
  }

  Future<bool> deleteData(String storeName, String uuid) async {
    Directory directory = await getApplicationDocumentsDirectory();

    // TODO Handle exception.
    await File('${directory.path}/$storeName/$uuid.txt').delete();
    return true;
  }

  @override
  Future<bool> writeData(String storeName, String dataId, String data) async {
    Directory directory = await getApplicationDocumentsDirectory();

    File dataFile = File('${directory.path}/$storeName/$dataId.txt');

    if (!await dataFile.exists()) {
      await dataFile.create();

      if (!await dataFile.exists()) {
        return false;
      }
    }

    await dataFile.writeAsString(data);
    return true;
  }
}
