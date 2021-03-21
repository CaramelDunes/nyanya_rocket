import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nyanya_rocket/screens/challenges/community_challenge_data.dart';
import 'package:nyanya_rocket/screens/puzzles/community_puzzle_data.dart';
import 'package:nyanya_rocket/services/firebase/firedart_firebase_service.dart';

import '../../config.dart';
import 'native_firebase_service.dart';

enum Sorting { ByDate, ByPopularity, ByName }

extension FieldName on Sorting {
  String get fieldName {
    switch (this) {
      case Sorting.ByDate:
        return 'date';
      case Sorting.ByPopularity:
        return 'likes';
      case Sorting.ByName:
        return 'name';
    }
  }
}

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
      apiKey: kFirebaseApiKey, //FIXME
      projectId: kFirebaseProjectId,
    );
    if (!_initComplete) {
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

  bool isSignedIn();

  Future<void> signOut();

  Future<bool> signInAnonymously();

  Stream<bool> signInStatusStream();

  Future<String?> idToken();

  Future<String?> displayName();

  Future<void> updateDisplayName(String newDisplayName);

  Stream<Map<String, dynamic>?> getDocStream(List<String> keys);

  Stream<List<Map<String, dynamic>>> getListStream(List<String> keys);

  Future<Map<String, dynamic>?> getDoc(List<String> keys);

  Future<List<Map<String, dynamic>>?> getCollection(List<String> keys);

  Future<String> addDoc(List<String> keys, Map<String, dynamic> json,
      {String? documentId, bool addUserPath = true});

  Future<void> updateDoc(List<String> keys, Map<String, dynamic> json);

  void deleteDoc(List<String> keys);

  Future<List<CommunityChallengeData>?> getCommunityChallenges(
      {required Sorting sortBy, required int limit});

  Future<List<CommunityPuzzleData>?> getCommunityPuzzles(
      {required Sorting sortBy, required int limit});

  Future<CommunityPuzzleData> getCommunityPuzzle(String id);

  Future<CommunityChallengeData> getCommunityChallenge(String id);

  Future<int?> getFeatureRequestThumbsUp(String id);

  Future<void> incrementFeatureRequestThumbsUp(String id);

  Future<int?> getCommunityStar(String path);

  Future<void> incrementCommunityStar(String path);

  Future<List<Map<String, dynamic>>?> getNews(String languageCode);
}

bool checkKeysForNull(List<String> keys) {
  if (keys.contains(null)) {
    print("ERROR: invalid key was passed to firestore: $keys");
    return false;
  }
  return true;
}
