import 'dart:convert';

import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/models/named_data_store.dart';

class MultiplayerStore extends NamedDataStore {
  MultiplayerStore() : super('multiplayer');

  Future<String> saveNewBoard(MultiplayerBoard boardData) async {
    return saveNewData(boardData.name, jsonEncode(boardData.toJson()));
  }

  Future<bool> updateBoard(String uuid, MultiplayerBoard boardData) async {
    return updateData(uuid, jsonEncode(boardData.toJson()));
  }

  Future<MultiplayerBoard> readBoard(String uuid) async {
    String jsonEncoded = await readData(uuid);

    return MultiplayerBoard.fromJson(jsonDecode(jsonEncoded));
  }

  Future<bool> deleteBoard(String uuid) async {
    return deleteData(uuid);
  }
}
