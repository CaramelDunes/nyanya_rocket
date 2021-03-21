import 'dart:convert';

import 'package:http/http.dart' as http;

class QueueJoinStatus {
  final String? ipAddress;
  final int? port;
  final int? ticket;

  QueueJoinStatus({this.ipAddress, this.port, this.ticket});
}

enum QueueType { Duels, FourPlayers }

class MultiplayerQueue {
  final String apiVersion = 'v1';

  final QueueType type;
  final http.Client client;
  final String masterServerHostname;

  int? length;
  bool joined = false;
  int position = 0;

  MultiplayerQueue(
      {required this.type,
      required this.client,
      required this.masterServerHostname});

  static _queueTypeToString(QueueType queueType) {
    switch (queueType) {
      case QueueType.Duels:
        return 'duels';
      case QueueType.FourPlayers:
        return 'fours';
    }
  }

  Future<void> queueLength() async {
    http.Response response = await client.get(Uri.https(
        masterServerHostname, '/$apiVersion/${_queueTypeToString(type)}/info'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      length = data['queueLength'];
    } else {
      throw Exception('Error ${response.statusCode} on queue info refresh.');
    }
  }

  Future<QueueJoinStatus> updateQueueJoinStatus() async {
    http.Response response = await client.get(Uri.https(masterServerHostname,
        '/$apiVersion/${_queueTypeToString(type)}/search'));

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
      } else {
        return QueueJoinStatus();
      }
    } else {
      throw Exception(
          'Could not get queue info: Got status code ${response.statusCode}.');
    }
  }

  Future<void> cancelSearch() async {
    http.Response response = await client.get(Uri.https(masterServerHostname,
        '/$apiVersion/${_queueTypeToString(type)}/cancel'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
    } else {
      throw Exception(
          'Could not cancel search: Got status code ${response.statusCode}.');
    }
  }
}
