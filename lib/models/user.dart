import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

enum StatusCode { success, failure, invalidArgument, unauthenticated }

class User with ChangeNotifier {
  final auth.FirebaseAuth authService;
  auth.User? innerUser;

  User(this.authService) {
    authService.userChanges().listen((auth.User? user) {
      innerUser = user;
      notifyListeners();
    });
  }

  bool get isConnected {
    return innerUser != null;
  }

  String? get displayName {
    return innerUser?.displayName;
  }

  Future<String?> idToken() async {
    return innerUser?.getIdToken();
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

      await innerUser!.updateDisplayName(newDisplayName);
      return response.statusCode == 200;
    }

    return false;
  }

  Future<bool> signInAnonymously() async {
    final auth.UserCredential credentials =
        await authService.signInAnonymously();

    innerUser = credentials.user;
    return isConnected;
  }

  Future<void> signOut() {
    return authService.signOut();
  }
}
