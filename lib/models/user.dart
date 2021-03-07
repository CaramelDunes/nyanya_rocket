import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:nyanya_rocket/services/firebase/firebase_service.dart';

enum StatusCode { Success, Failure, InvalidArgument, Unauthenticated }

class User with ChangeNotifier {
  auth.User? _user;

  User() {
    if (FirebaseFactory.useNative)
      auth.FirebaseAuth.instance.userChanges().listen((user) {
        _user = user;

        if (isConnected) {
          print('User connected as `$user`');
        } else {
          print('User not connected');
        }

        notifyListeners();
      });
  }

  bool get isConnected {
    return _user != null;
  }

  String get displayName {
    return _user?.displayName ?? '';
  }

  Future<StatusCode> setDisplayName(String newDisplayName) async {
    if (isConnected) {
      try {
        await FirebaseFunctions.instance
            .httpsCallable('setDisplayName')
            .call({'displayName': newDisplayName});
      } on FirebaseFunctionsException catch (e) {
        print(e.code);

        switch (e.code) {
          case 'INVALID_ARGUMENT':
            return StatusCode.InvalidArgument;

          case 'UNAUTHENTICATED':
            return StatusCode.Unauthenticated;
        }

        return StatusCode.Failure;
      }

      await _user!.updateProfile(displayName: newDisplayName);

      return StatusCode.Success;
    }

    return StatusCode.Success;
  }

  Future<auth.User?> signInAnonymously() async {
    auth.UserCredential result =
        await auth.FirebaseAuth.instance.signInAnonymously();
    _user = result.user;
    notifyListeners();

    return result.user;
  }

  Future<void> signOut() async {
    await auth.FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }
}
