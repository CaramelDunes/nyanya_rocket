import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> setDisplayName(String newDisplayName) async {
    if (isConnected) {
      await _user.updateProfile(UserUpdateInfo()..displayName = newDisplayName);

      Firestore.instance
          .document('users/${_user.uid}')
          .setData({'display_name': newDisplayName});

      _user = await FirebaseAuth.instance.currentUser();
    }

    return;
  }

  String get uid {
    return isConnected ? _user.uid : '';
  }

  bool get isAnonymous {
    return !isConnected || _user.isAnonymous;
  }
}
