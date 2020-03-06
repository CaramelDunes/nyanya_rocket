import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

enum StatusCode { Success, Failure, InvalidArgument, Unauthenticated }

class User with ChangeNotifier {
  FirebaseUser _user;

  User() {
    _refreshCurrentUser();
  }

  bool get isConnected {
    return _user != null;
  }

  String get displayName {
    return isConnected ? _user.displayName : '';
  }

  Future<String> authToken() async {
    if (isConnected) {
      return (await _user.getIdToken()).token;
    }

    return null;
  }

  Future<StatusCode> setDisplayName(String newDisplayName) async {
    if (isConnected) {
      try {
        await CloudFunctions.instance
            .getHttpsCallable(functionName: 'setDisplayName')
            .call({'displayName': newDisplayName}).then(
                (HttpsCallableResult result) {
        });
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
      await _refreshCurrentUser();

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

  Future signInAnonymously() async {
    AuthResult result = await FirebaseAuth.instance.signInAnonymously();
    _user = result.user;
    notifyListeners();
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }

  Future _refreshCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    _user = user;
    notifyListeners();

    if (isConnected) {
      print('User connected as `$displayName`');
    } else {
      print('User not connected');
    }
  }
}
