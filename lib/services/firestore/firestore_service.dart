import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nyanya_rocket/screens/challenges/community_challenge_data.dart';
import 'package:nyanya_rocket/screens/puzzles/community_puzzle_data.dart';

import '../../config.dart';
import 'firedart_firestore_service.dart';
import 'native_firestore_service.dart';

enum Sorting { byDate, byPopularity, byName }

extension FieldName on Sorting {
  String get fieldName {
    switch (this) {
      case Sorting.byDate:
        return 'date';
      case Sorting.byPopularity:
        return 'likes';
      case Sorting.byName:
        return 'name';
    }
  }
}

// Returns the correct Firebase instance depending on platform
class FirestoreFactory {
  static bool _initComplete = false;

  static bool get useNative =>
      kIsWeb ||
      Platform.isAndroid ||
      Platform.isIOS; // || UniversalPlatform.isMacOS;

  static Future<FirestoreService> create() async {
    FirestoreService service = useNative
        ? NativeFirestoreService()
        : FiredartFirebaseService(
            apiKey: kFirebaseApiKey,
            projectId: kFirebaseProjectId,
          );
    if (!_initComplete) {
      _initComplete = true;
      await service.init();
    }
    print('Using Firestore ${useNative ? 'NATIVE' : 'DART'}.');
    return service;
  }
}

// Interface / Base class
// Combination of abstract methods that must be implemented, and concrete methods that are shared.
abstract class FirestoreService {
  // Helper method for getting a path from keys, and optionally prepending the scope (users/email)
  String getPathFromKeys(List<String> keys, {bool addUserPath = true}) {
    return keys.join("/");
  }

  Future<void> init();

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
