import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class QueueJoinStatus {
  final int position;
  final int queueLength;
  final String ipAddress;
  final int port;
  final int ticket;

  QueueJoinStatus(
      {this.position,
      this.queueLength,
      this.ipAddress,
      this.port,
      this.ticket});
}

enum QueueType { Duels, FourPlayers }

abstract class QueueClient {
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

  static Future<int> queueSize(
      {@required String authToken,
      @required String masterServerHostname,
      @required QueueType queueType}) async {
    Map<String, String> headers = {'Authorization': authToken};

    http.Response response = await http.get(
        'http://$masterServerHostname/${_queueTypeToString(queueType)}/info',
        headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      return data['queueSize'];
    } else {
      print('Error ${response.statusCode} on queue info refresh.');
      throw Error();
    }
  }

  static Future<QueueJoinStatus> updateQueueJoinStatus(
      {@required String authToken,
      @required String masterServerHostname,
      @required QueueType queueType}) async {
    try {
      Map<String, String> headers = {'Authorization': authToken};

      http.Response response = await http.get(
          'http://$masterServerHostname/${_queueTypeToString(queueType)}/search',
          headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('position')) {
          return QueueJoinStatus(
              position: data['position'].toInt(),
              queueLength: data['queueLength'].toInt());
        } else if (data.containsKey('port')) {
          return QueueJoinStatus(
              ipAddress: data['ipAddress'],
              port: data['port'].toInt(),
              ticket: data['ticket'].toInt());
        } else {
          print('Error ${response.statusCode} on queue info refresh.');
        }
      }
    } catch (e) {
      print('Could not refresh queue info: $e');
    }

    return null;
  }
}
