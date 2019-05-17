import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum StatusCode { Success, Failure, InvalidArgument, Unauthenticated }

class User {
  FirebaseUser _user;

  User() {
    FirebaseAuth.instance
        .currentUser()
        .then((FirebaseUser user) => _user = user);
  }

  bool get isConnected {
    return _user != null;
  }

  String get displayName {
    return isConnected ? _user.displayName : '';
  }

  Future<StatusCode> setDisplayName(String newDisplayName) async {
    if (isConnected) {
      try {
        await CloudFunctions.instance
            .getHttpsCallable(functionName: 'setDisplayName')
            .call({'displayName': newDisplayName}).then(
                (HttpsCallableResult result) {
          print(result);
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
      _user = await FirebaseAuth.instance.currentUser();

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

  Future<void> signInAnonymously() {
    return FirebaseAuth.instance.signInAnonymously().then((FirebaseUser user) {
      _user = user;
      return;
    });
  }

  Future<void> signOut() {
    return FirebaseAuth.instance.signOut().then((void _) {
      _user = null;
    });
  }
}
