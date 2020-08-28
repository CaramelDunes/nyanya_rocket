import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';

enum StatusCode { Success, Failure, InvalidArgument, Unauthenticated }

class User with ChangeNotifier {
  auth.User _user;

  User() {
    _refreshCurrentUser();

    auth.FirebaseAuth.instance.userChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  bool get isConnected {
    return _user != null;
  }

  String get displayName {
    return isConnected ? _user.displayName : '';
  }

  Future<String> authToken() async {
    if (isConnected) {
      return await _user.getIdToken();
    }

    return null;
  }

  Future<StatusCode> setDisplayName(String newDisplayName) async {
    if (isConnected) {
      try {
        await CloudFunctions.instance
            .getHttpsCallable(functionName: 'setDisplayName')
            .call({'displayName': newDisplayName}).then(
                (HttpsCallableResult result) {});
      } catch (e) {
        print(e.code);

        switch (e.code) {
          case 'INVALID_ARGUMENT':
            return StatusCode.InvalidArgument;
            break;

          case 'UNAUTHENTICATED':
            return StatusCode.Unauthenticated;
            break;
        }

        return StatusCode.Failure;
      }

      await _user.reload();
      _refreshCurrentUser();

      return StatusCode.Success;
    }

    return StatusCode.Success;
  }

  String get uid {
    return isConnected ? _user.uid : '';
  }

  bool get isAnonymous {
    return !isConnected || _user.isAnonymous;
  }

  Future<User> signInAnonymously() async {
    auth.UserCredential result =
        await auth.FirebaseAuth.instance.signInAnonymously();
    _user = result.user;
    notifyListeners();

    return this;
  }

  Future signOut() async {
    await auth.FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }

  void _refreshCurrentUser() {
    auth.User user = auth.FirebaseAuth.instance.currentUser;
    _user = user;
    notifyListeners();

    if (isConnected) {
      print('User connected as `$uid`');
    } else {
      print('User not connected');
    }
  }
}
