import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class MultiplayerStore {
  HashMap<String, String> _entries = HashMap();

  File _registryFile;

  final Uuid uuid = Uuid();
  final String registryLocation = 'multiplayer/registry.txt';

  Future<HashMap> readRegistry() async {
    _entries.clear();

    Directory directory = await getApplicationDocumentsDirectory();

    _registryFile = File('${directory.path}/$registryLocation');

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

    _registryFile = File('${directory.path}/$registryLocation');

    if (!_registryFile.existsSync()) {
      _registryFile.createSync(recursive: true);

      if (!_registryFile.existsSync()) {
        return false;
      }
    }

    _registryFile.writeAsStringSync(stringValue);

    return true;
  }

  Future<bool> _writeBoard(String uuid, MultiplayerBoard board) async {
    Directory directory = await getApplicationDocumentsDirectory();

    File boardFile = File('${directory.path}/multiplayer/$uuid.txt');

    if (!boardFile.existsSync()) {
      boardFile.createSync();

      if (!boardFile.existsSync()) {
        return false;
      }
    }

    await boardFile.writeAsString(jsonEncode(board.toJson()));

    return true;
  }

  Future<String> saveNewBoard(MultiplayerBoard board) async {
    await readRegistry();

    String newUuid = uuid.v4();

    if (!_entries.containsKey(newUuid)) {
      if (await _writeBoard(newUuid, board)) {
        _entries[newUuid] = board.name;
        _writeRegistry();
        return newUuid;
      }
    }

    return '';
  }

  Future<bool> updateBoard(
      String uuid, MultiplayerBoard multiplayerBoard) async {
    await readRegistry();

    if (_entries.containsKey(uuid) &&
        await _writeBoard(uuid, multiplayerBoard)) {
      _entries[uuid] = multiplayerBoard.name;
      return true;
    }

    return false;
  }

  Future<MultiplayerBoard> readBoard(String uuid) async {
    if (_entries.containsKey(uuid)) {
      Directory directory = await getApplicationDocumentsDirectory();

      File boardFile = File('${directory.path}/multiplayer/$uuid.txt');

      if (boardFile.existsSync()) {
        var readAsStringSync = boardFile.readAsStringSync();
        MultiplayerBoard data =
            MultiplayerBoard.fromJson(jsonDecode(readAsStringSync));

        return data;
      }
    }

    return null;
  }

  Future<bool> deleteBoard(String uuid) async {
    if (_entries.containsKey(uuid)) {
      Directory directory = await getApplicationDocumentsDirectory();

      File('${directory.path}/multiplayer/$uuid.txt').deleteSync();

      _entries.remove(uuid);
      await _writeRegistry();
      return true;
    }

    return false;
  }

  HashMap get entries => _entries;
}
