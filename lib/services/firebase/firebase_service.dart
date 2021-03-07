import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nyanya_rocket/services/firebase/firedart_firebase_service.dart';

import 'native_firebase_service.dart';

// Returns the correct Firebase instance depending on platform
class FirebaseFactory {
  static bool _initComplete = false;

  static bool get useNative =>
      kIsWeb ||
      Platform.isAndroid ||
      Platform.isIOS; // || UniversalPlatform.isMacOS;

  static FirebaseService create() {
    FirebaseService service = useNative
        ? NativeFirebaseService()
        : FiredartFirebaseService(
            apiKey: 'AIzaSyBExG_dHwDwU9H2mEwawd0p5pzy2Atm-IY', //FIXME
            projectId: 'nyanya-rocket',
          );
    if (_initComplete == false) {
      _initComplete = true;
      service.init();
    }
    print("firestore-${useNative ? "NATIVE" : "DART"} Initialized");
    return service;
  }
}

// Interface / Base class
// Combination of abstract methods that must be implemented, and concrete methods that are shared.
abstract class FirebaseService {
  // Helper method for getting a path from keys, and optionally prepending the scope (users/email)
  String getPathFromKeys(List<String> keys, {bool addUserPath = true}) {
    return keys.join("/");
  }

  void init();

  Stream<Map<String, dynamic>?> getDocStream(List<String> keys);

  Stream<List<Map<String, dynamic>>> getListStream(List<String> keys);

  Future<Map<String, dynamic>?> getDoc(List<String> keys);

  Future<List<Map<String, dynamic>?>> getCollection(List<String> keys);

  Future<String> addDoc(List<String> keys, Map<String, dynamic> json,
      {String? documentId, bool addUserPath = true});

  Future<void> updateDoc(List<String> keys, Map<String, dynamic> json);

  void deleteDoc(List<String> keys);
}

bool checkKeysForNull(List<String> keys) {
  if (keys.contains(null)) {
    print("ERROR: invalid key was passed to firestore: $keys");
    return false;
  }
  return true;
}
