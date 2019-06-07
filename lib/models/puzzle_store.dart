import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'named_puzzle_data.dart';

class PuzzleStore {
  LinkedHashMap<String, String> _entries = LinkedHashMap();

  File _registryFile;

  final Uuid uuid = Uuid();

  Future<Map> readRegistry() async {
    _entries.clear();

    Directory directory = await getApplicationDocumentsDirectory();

    _registryFile = File('${directory.path}/puzzles/registry.txt');

    if (!_registryFile.existsSync()) {
      _registryFile.createSync(recursive: true);
      return _entries;
    }

    String contents = _registryFile.readAsStringSync();

    for (String entry in contents.split('\n')) {
      int separator = entry.indexOf(';');

      if (separator == -1) {
        if (entry.isNotEmpty) {
          print('Ignoring invalid entry: $entry');
        }
        continue;
      }

      _entries[entry.substring(0, separator)] = entry.substring(separator + 1);
    }

    return _entries;
  }

  Future<bool> _writeRegistry() async {
    String stringValue = '';

    _entries
        .forEach((String uuid, String name) => stringValue += '$uuid;$name\n');

    Directory directory = await getApplicationDocumentsDirectory();

    _registryFile = File('${directory.path}/puzzles/registry.txt');

    if (!_registryFile.existsSync()) {
      _registryFile.createSync(recursive: true);

      if (!_registryFile.existsSync()) {
        return false;
      }
    }

    _registryFile.writeAsStringSync(stringValue);

    return true;
  }

  Future<bool> _writePuzzle(String uuid, NamedPuzzleData puzzleData) async {
    Directory directory = await getApplicationDocumentsDirectory();

    File puzzleFile = File('${directory.path}/puzzles/$uuid.txt');

    if (!puzzleFile.existsSync()) {
      puzzleFile.createSync();

      if (!puzzleFile.existsSync()) {
        return false;
      }
    }

    await puzzleFile.writeAsString(jsonEncode(puzzleData.toJson()));

    return true;
  }

  Future<String> saveNewPuzzle(NamedPuzzleData puzzleData) async {
    await readRegistry();

    String newUuid = uuid.v4();

    if (!_entries.containsKey(newUuid)) {
      if (await _writePuzzle(newUuid, puzzleData)) {
        _entries[newUuid] = puzzleData.name;
        _writeRegistry();
        return newUuid;
      }
    }

    return '';
  }

  Future<bool> updatePuzzle(String uuid, NamedPuzzleData puzzleData) async {
    await readRegistry();

    if (_entries.containsKey(uuid) && await _writePuzzle(uuid, puzzleData)) {
      _entries.remove(uuid);
      _entries[uuid] = puzzleData.name;
      _writeRegistry();
      return true;
    }

    return false;
  }

  Future<NamedPuzzleData> readPuzzle(String uuid) async {
    if (_entries.containsKey(uuid)) {
      Directory directory = await getApplicationDocumentsDirectory();

      File puzzleFile = File('${directory.path}/puzzles/$uuid.txt');

      if (puzzleFile.existsSync()) {
        var readAsStringSync = puzzleFile.readAsStringSync();
        NamedPuzzleData data =
            NamedPuzzleData.fromJson(jsonDecode(readAsStringSync));

        return data;
      }
    }

    return null;
  }

  Future<bool> deletePuzzle(String uuid) async {
    if (_entries.containsKey(uuid)) {
      Directory directory = await getApplicationDocumentsDirectory();

      File('${directory.path}/puzzles/$uuid.txt').deleteSync();

      _entries.remove(uuid);
      await _writeRegistry();
      return true;
    }

    return false;
  }

  Map get entries => _entries;
}
