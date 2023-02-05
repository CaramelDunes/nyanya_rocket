import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class QueueJoinStatus {
  final String? roomId;
  final String? ipAddress;
  final int? port;
  final int? ticket;

  QueueJoinStatus({this.roomId, this.ipAddress, this.port, this.ticket});
}

class PrivateQueue {
  final String apiVersion = 'v1';

  final http.Client client;

  int? length;
  bool joined = false;
  int position = 0;

  PrivateQueue({required this.client});

  Future<QueueJoinStatus> updateQueueCreateStatus(
      {required String masterServerHostname}) async {
    http.Response response = await client
        .get(Uri.http(masterServerHostname, '/$apiVersion/private/roomCode'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey('roomId')) {
        return QueueJoinStatus(roomId: data['roomId']);
      } else {
        return QueueJoinStatus(
            ipAddress: data['ipAddress'],
            port: data['port'].toInt(),
            ticket: data['ticket'].toInt());
      }
    } else {
      throw Exception(
          'Could not get queue info: Got status code ${response.statusCode}.');
    }
  }

  Future<QueueJoinStatus> updateQueueJoinStatus(
      {required String masterServerHostname, required String roomCode}) async {
    http.Response response = await client.get(Uri.http(masterServerHostname,
        '/$apiVersion/private/join', {'roomCode': roomCode}));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      debugPrint(data.toString());

      if (data.containsKey('port')) {
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

  Future<void> cancelSearch({required String masterServerHostname}) async {
    http.Response response = await client
        .get(Uri.http(masterServerHostname, '/$apiVersion/private/cancel'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      debugPrint(data.toString());
    } else {
      throw Exception(
          'Could not cancel search: Got status code ${response.statusCode}.');
    }
  }
}
