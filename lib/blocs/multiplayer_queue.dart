import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class QueueJoinStatus {
  final String ipAddress;
  final int port;
  final int ticket;

  QueueJoinStatus({this.ipAddress, this.port, this.ticket});
}

enum QueueType { Duels, FourPlayers }

class MultiplayerQueue {
  final String apiVersion = 'v1';

  final QueueType type;
  int length;
  bool joined = false;
  int position = 0;

  MultiplayerQueue({@required this.type});

  static _queueTypeToString(QueueType queueType) {
    switch (queueType) {
      case QueueType.Duels:
        return 'duels';
        break;
      case QueueType.FourPlayers:
        return 'fours';
        break;
    }
  }

  Future queueLength(
      {@required String authToken,
      @required String masterServerHostname}) async {
    Map<String, String> headers = {'Authorization': authToken};

    http.Response response = await http.get(
        'http://$masterServerHostname/$apiVersion/${_queueTypeToString(type)}/info',
        headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      length = data['queueLength'];
    } else {
      throw Exception('Error ${response.statusCode} on queue info refresh.');
    }
  }

  Future<QueueJoinStatus> updateQueueJoinStatus(
      {@required String authToken,
      @required String masterServerHostname}) async {
    Map<String, String> headers = {'Authorization': authToken};

    http.Response response = await http.get(
        'http://$masterServerHostname/$apiVersion/${_queueTypeToString(type)}/search',
        headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey('position')) {
        position = data['position'].toInt();
        length = data['queueLength'].toInt();

        return QueueJoinStatus();
      } else if (data.containsKey('port')) {
        return QueueJoinStatus(
            ipAddress: data['ipAddress'],
            port: data['port'].toInt(),
            ticket: data['ticket'].toInt());
      }
    } else {
      throw Exception(
          'Could not get queue info: Got status code ${response.statusCode}.');
    }

    return null;
  }

  Future cancelSearch(
      {@required String authToken,
      @required String masterServerHostname}) async {
    Map<String, String> headers = {'Authorization': authToken};

    http.Response response = await http.get(
        'http://$masterServerHostname/$apiVersion/${_queueTypeToString(type)}/cancel',
        headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
    } else {
      throw Exception(
          'Could not cancel search: Got status code ${response.statusCode}.');
    }
  }
}
