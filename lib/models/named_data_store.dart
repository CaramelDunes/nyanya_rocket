import 'dart:collection';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class NamedDataStore {
  final String storeName;

  LinkedHashMap<String, String> _entries = LinkedHashMap();

  final Uuid uuid = Uuid();

  NamedDataStore(this.storeName);

  Future<Map<String, String>> readRegistry() async {
    _entries.clear();

    Directory? directory = await getApplicationSupportDirectory();

    if (directory != null) {
      File _registryFile = File('${directory.path}/$storeName/registry.txt');

      if (!await _registryFile.exists()) {
        await _registryFile.create(recursive: true);
        return _entries;
      }

      String contents = await _registryFile.readAsString();

      for (String entry in contents.split('\n')) {
        int separator = entry.indexOf(';');

        if (separator == -1) {
          if (entry.isNotEmpty) {
            print('Ignoring invalid entry: $entry');
          }
          continue;
        }

        _entries[entry.substring(0, separator)] =
            entry.substring(separator + 1);
      }

      return _entries;
    }

    return Map();
  }

  Future<bool> _writeRegistry() async {
    String stringValue = '';

    _entries
        .forEach((String uuid, String name) => stringValue += '$uuid;$name\n');

    Directory? directory = await getApplicationDocumentsDirectory();

    if (directory != null) {
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

    return false;
  }

  Future<bool> _writeData(String uuid, String data) async {
    Directory? directory = await getApplicationDocumentsDirectory();

    if (directory != null) {
      File dataFile = File('${directory.path}/$storeName/$uuid.txt');

      if (!await dataFile.exists()) {
        await dataFile.create();

        if (!await dataFile.exists()) {
          return false;
        }
      }

      await dataFile.writeAsString(data);
      return true;
    }

    return false;
  }

  Future<String> saveNewData(String name, String data) async {
    await readRegistry();

    String newUuid = uuid.v4();

    if (!_entries.containsKey(newUuid)) {
      if (await _writeData(newUuid, data)) {
        _entries[newUuid] = name;
        await _writeRegistry();
        return newUuid;
      }
    }

    return '';
  }

  Future<bool> updateData(String uuid, String data) async {
    await readRegistry();

    if (_entries.containsKey(uuid) && await _writeData(uuid, data)) {
      await _writeRegistry();
      return true;
    }

    return false;
  }

  Future<bool> updateName(String uuid, String name) async {
    await readRegistry();

    if (_entries.containsKey(uuid)) {
      _entries[uuid] = name;
      await _writeRegistry();
      return true;
    }

    return false;
  }

  Future<String> readData(String uuid) async {
    if (_entries.containsKey(uuid)) {
      Directory? directory = await getApplicationDocumentsDirectory();

      if (directory != null) {
        File dataFile = File('${directory.path}/$storeName/$uuid.txt');

        if (await dataFile.exists()) {
          return dataFile.readAsString();
        }
      }
    }

    return ''; // TODO Better error handling
  }

  Future<bool> deleteData(String uuid) async {
    if (_entries.containsKey(uuid)) {
      Directory? directory = await getApplicationDocumentsDirectory();

      if (directory != null) {
        await File('${directory.path}/$storeName/$uuid.txt').delete();

        _entries.remove(uuid);
        await _writeRegistry();
        return true;
      }
    }

    return false;
  }

  Map get entries => _entries;
}
