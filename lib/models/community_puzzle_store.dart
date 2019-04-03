import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class Entry {
  final int likes;
  final String name;
  final String author;

  Entry({this.likes, this.name, this.author});

  static Entry fromJson(Map<String, dynamic> json) {
    return Entry(
        name: json['name'], author: json['author'], likes: json['likes']);
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'author': author, 'likes': likes};
}

class CommunityPuzzleStore {
  HashMap<String, Entry> _entries = HashMap();

  File _registryFile;

  final Uuid uuid = Uuid();

  void consume(QuerySnapshot snapshot) {
    for (DocumentSnapshot document in snapshot.documents) {
      _entries[document.documentID] = Entry(
          likes: document['likes'],
          name: document['name'],
          author: document['author']);
      _writePuzzle(document.documentID, document['puzzle_data']);
    }

    _writeRegistry();
  }

  Future<HashMap> readRegistry() async {
    _entries.clear();

    Directory directory = await getTemporaryDirectory();

    _registryFile =
        File('${directory.path}/nyanya_rocket/puzzles/registry.txt');

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
          Entry.fromJson(jsonDecode(entry.substring(separator + 1)));
    }

    return _entries;
  }

  Future<bool> _writeRegistry() async {
    String stringValue = '';

    _entries.forEach((String uuid, Entry entry) =>
        stringValue += '$uuid;${jsonEncode(entry.toJson())}\n');

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

  Future<bool> _writePuzzle(String uuid, String puzzleData) async {
    Directory directory = await getTemporaryDirectory();

    File puzzleFile = File('${directory.path}/nyanya_rocket/puzzles/$uuid.txt');

    if (!await puzzleFile.exists()) {
      await puzzleFile.create(recursive: true);

      if (!await puzzleFile.exists()) {
        return false;
      }
    }

    await puzzleFile.writeAsString(puzzleData);

    return true;
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

  HashMap get entries => _entries;
}
