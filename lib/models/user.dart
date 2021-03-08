import 'package:flutter/foundation.dart';
import 'package:nyanya_rocket/services/firebase/firebase_service.dart';

enum StatusCode { Success, Failure, InvalidArgument, Unauthenticated }

class User with ChangeNotifier {
  String? _displayName;
  bool _signedIn = false;
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
    return _signedIn;
  }

  String get displayName {
    return _displayName ?? '';
  }

  Future<String?> idToken() => firebaseService.idToken();

  Stream<bool> get signedInStream =>
      firebaseService.signInStatusStream().asBroadcastStream();

  Future<StatusCode> setDisplayName(String newDisplayName) async {
    if (isConnected) {
      // TODO
      // try {
      //   await FirebaseFunctions.instance
      //       .httpsCallable('setDisplayName')
      //       .call({'displayName': newDisplayName});
      // } on FirebaseFunctionsException catch (e) {
      //   print(e.code);
      //
      //   switch (e.code) {
      //     case 'INVALID_ARGUMENT':
      //       return StatusCode.InvalidArgument;
      //
      //     case 'UNAUTHENTICATED':
      //       return StatusCode.Unauthenticated;
      //   }
      //
      //   return StatusCode.Failure;
      // }
      //
      // await _user!.updateProfile(displayName: newDisplayName);
      //
      // return StatusCode.Success;
    }

    return StatusCode.Success;
  }

  Future<bool> signInAnonymously() {
    return firebaseService.signInAnonymously();
  }

  Future<void> signOut() async {
    await firebaseService.signOut();
  }
}
