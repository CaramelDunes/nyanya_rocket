import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class CommunityPuzzleStore {
  HashMap<String, String> _entries = HashMap();

  File _registryFile;

  final Uuid uuid = Uuid();

  Future<HashMap> readRegistry() async {
    _entries.clear();

    Directory directory = await getTemporaryDirectory();

    _registryFile =
        File('${directory.path}/nyanya_rocket/puzzles/registry.txt');

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

    Directory directory = await getTemporaryDirectory();

    _registryFile =
        File('${directory.path}/nyanya_rocket/puzzles/registry.txt');

    if (!_registryFile.existsSync()) {
      _registryFile.createSync(recursive: true);

      if (!_registryFile.existsSync()) {
        return false;
      }
    }

    _registryFile.writeAsStringSync(stringValue);

    return true;
  }

  Future<bool> _writePuzzle(String uuid, PuzzleData puzzleData) async {
    Directory directory = await getTemporaryDirectory();

    File puzzleFile = File('${directory.path}/nyanya_rocket/puzzles/$uuid.txt');

    if (!puzzleFile.existsSync()) {
      puzzleFile.createSync();

      if (!puzzleFile.existsSync()) {
        return false;
      }
    }

    await puzzleFile.writeAsString(jsonEncode(puzzleData.toJson()));

    return true;
  }

  Future<String> saveNewPuzzle(PuzzleData puzzleData) async {
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

  Future<bool> updatePuzzle(String uuid, PuzzleData puzzleData) async {
    await readRegistry();

    if (_entries.containsKey(uuid) && await _writePuzzle(uuid, puzzleData)) {
      _entries[uuid] = puzzleData.name;
      return true;
    }

    return false;
  }

  Future<PuzzleData> readPuzzle(String uuid) async {
    if (_entries.containsKey(uuid)) {
      Directory directory = await getTemporaryDirectory();

      File puzzleFile =
          File('${directory.path}/nyanya_rocket/puzzles/$uuid.txt');

      if (puzzleFile.existsSync()) {
        var readAsStringSync = puzzleFile.readAsStringSync();
        PuzzleData data = PuzzleData.fromJson(jsonDecode(readAsStringSync));

        return data;
      }
    }

    return null;
  }

  Future<bool> deletePuzzle(String uuid) async {
    if (_entries.containsKey(uuid)) {
      Directory directory = await getTemporaryDirectory();

      File('${directory.path}/nyanya_rocket/puzzles/$uuid.txt').deleteSync();

      _entries.remove(uuid);
      await _writeRegistry();
      return true;
    }

    return false;
  }

  HashMap get entries => _entries;
}
