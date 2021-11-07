import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:nyanya_rocket/services/firebase/firebase_service.dart';
import 'package:http/http.dart' as http;

enum StatusCode { success, failure, invalidArgument, unauthenticated }

class User with ChangeNotifier {
  String? _displayName;
  final FirebaseService firebaseService;

  User(this.firebaseService) {
    // firebaseService.signInStatusStream().asBroadcastStream().listen((signedIn) {
    //   if (signedIn) {
    //     print('User connected');
    //   } else {
    //     print('User not connected');
    //   }
    //   _signedIn = signedIn;
    //   notifyListeners();
    // });
  }

  bool get isConnected {
    return firebaseService.isSignedIn();
  }

  String get displayName {
    return _displayName ?? '';
  }

  Future<String?> idToken() => firebaseService.idToken();

  Stream<bool> get signedInStream => firebaseService.signInStatusStream();

  Future<bool> setDisplayName(String newDisplayName) async {
    final token = await idToken();
    if (token != null) {
      // Some doc: https://github.com/firebase/firebase-functions/blob/master/src/providers/https.ts
      http.Response response = await http.post(
          Uri.https('us-central1-nyanya-rocket.cloudfunctions.net',
              '/setDisplayName'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'data': {'displayName': newDisplayName}
          }));

      await firebaseService.updateDisplayName(newDisplayName);
      return response.statusCode == 200;
    }

    return false;
  }

  Future<bool> signInAnonymously() {
    return firebaseService.signInAnonymously();
  }

  Future<void> signOut() async {
    await firebaseService.signOut();
  }
}
