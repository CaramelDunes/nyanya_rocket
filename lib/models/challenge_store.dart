import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:nyanya_rocket/models/named_challenge_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ChallengeStore {
  LinkedHashMap<String, String> _entries = LinkedHashMap();

  File _registryFile;

  final Uuid uuid = Uuid();

  Future<Map> readRegistry() async {
    _entries.clear();

    Directory directory = await getApplicationDocumentsDirectory();

    _registryFile = File('${directory.path}/challenges/registry.txt');

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

    _registryFile = File('${directory.path}/challenges/registry.txt');

    if (!_registryFile.existsSync()) {
      _registryFile.createSync(recursive: true);

      if (!_registryFile.existsSync()) {
        return false;
      }
    }

    _registryFile.writeAsStringSync(stringValue);

    return true;
  }

  Future<bool> _writeChallenge(
      String uuid, NamedChallengeData challengeData) async {
    Directory directory = await getApplicationDocumentsDirectory();

    File challengeFile = File('${directory.path}/challenges/$uuid.txt');

    if (!challengeFile.existsSync()) {
      challengeFile.createSync();

      if (!challengeFile.existsSync()) {
        return false;
      }
    }

    await challengeFile.writeAsString(jsonEncode(challengeData.toJson()));

    return true;
  }

  Future<String> saveNewChallenge(NamedChallengeData challengeData) async {
    await readRegistry();

    String newUuid = uuid.v4();

    if (!_entries.containsKey(newUuid)) {
      if (await _writeChallenge(newUuid, challengeData)) {
        _entries[newUuid] = challengeData.name;
        _writeRegistry();
        return newUuid;
      }
    }

    return '';
  }

  Future<bool> updateChallenge(
      String uuid, NamedChallengeData challengeData) async {
    await readRegistry();

    if (_entries.containsKey(uuid) &&
        await _writeChallenge(uuid, challengeData)) {
      _entries.remove(uuid);
      _entries[uuid] = challengeData.name;
      _writeRegistry();
      return true;
    }

    return false;
  }

  Future<NamedChallengeData> readChallenge(String uuid) async {
    if (_entries.containsKey(uuid)) {
      Directory directory = await getApplicationDocumentsDirectory();

      File challengeFile = File('${directory.path}/challenges/$uuid.txt');

      if (challengeFile.existsSync()) {
        var readAsStringSync = challengeFile.readAsStringSync();
        NamedChallengeData data =
            NamedChallengeData.fromJson(jsonDecode(readAsStringSync));

        return data;
      }
    }

    return null;
  }

  Future<bool> deleteChallenge(String uuid) async {
    if (_entries.containsKey(uuid)) {
      Directory directory = await getApplicationDocumentsDirectory();

      File('${directory.path}/challenges/$uuid.txt').deleteSync();

      _entries.remove(uuid);
      await _writeRegistry();
      return true;
    }

    return false;
  }

  Map get entries => _entries;
}
