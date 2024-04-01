import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

enum StatusCode { success, failure, invalidArgument, unauthenticated }

class User with ChangeNotifier {
  final auth.FirebaseAuth? _authService;
  auth.User? _innerUser;

  User(this._authService) {
    _authService?.userChanges().listen((auth.User? user) {
      _innerUser = user;
      notifyListeners();
    });
  }

  bool get isConnected {
    return _innerUser != null;
  }

  String? get displayName {
    return _innerUser?.displayName;
  }

  Future<String?> idToken() async {
    return _innerUser?.getIdToken();
  }

  Future<bool> setDisplayName(String newDisplayName) async {
    final token = await idToken();

    if (token != null) {
      // https://github.com/firebase/firebase-functions/blob/master/src/providers/https.ts
      http.Response response = await http.post(
          Uri.https(kCloudFunctionsHost, '/setDisplayName'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'data': {'displayName': newDisplayName}
          }));

      await _innerUser!.updateDisplayName(newDisplayName);
      return response.statusCode == 200;
    }

    return false;
  }

  Future<bool> signInAnonymously() async {
    if (_authService == null) return Future.value(false);

    final auth.UserCredential credentials =
        await _authService.signInAnonymously();

    _innerUser = credentials.user;
    return isConnected;
  }

  Future<void> signOut() {
    if (_authService == null) return Future.value();

    return _authService.signOut();
  }
}
