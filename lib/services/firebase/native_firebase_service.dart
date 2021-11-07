import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:nyanya_rocket/screens/challenges/community_challenge_data.dart';
import 'package:nyanya_rocket/screens/puzzles/community_puzzle_data.dart';

import 'firebase_service.dart';

class NativeFirebaseService extends FirebaseService {
  String? userId;

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  FirebaseAuth get auth => FirebaseAuth.instance;

  @override
  Future<void> init() async {
    await Firebase.initializeApp().catchError((Object e) {
      print("$e");
    }).then((value) {
      print("InitComplete");
    });

    // setPersistence() is only supported on web based platforms
    if (kIsWeb) {
      await auth.setPersistence(Persistence.LOCAL);
    }
  }

  // Streams
  @override
  Stream<Map<String, dynamic>> getDocStream(List<String> keys) {
    return _getDoc(keys)!.snapshots().map((doc) => doc.data()!);
  }

  @override
  Stream<List<Map<String, dynamic>>> getListStream(List<String> keys) {
    return _getCollection(keys)!.snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs.map((d) => d.data()).toList();
      },
    );
  }

  // CRUD
  @override
  Future<String> addDoc(List<String> keys, Map<String, dynamic> json,
      {String? documentId, bool addUserPath = true}) async {
    if (documentId != null) {
      keys.add(documentId);
      print("Add Doc ${getPathFromKeys(keys)}");
      await firestore
          .doc(getPathFromKeys(keys, addUserPath: addUserPath))
          .set(json);
      print("Add Doc Complete");
      return documentId;
    }
    CollectionReference ref =
        firestore.collection(getPathFromKeys(keys, addUserPath: addUserPath));
    final doc = await ref.add(json);
    return (doc).id;
  }

  @override
  Future<void> deleteDoc(List<String> keys) async =>
      await firestore.doc(getPathFromKeys(keys)).delete();

  @override
  Future<void> updateDoc(List<String> keys, Map<String, dynamic> json,
      [bool update = false]) async {
    await firestore.doc(getPathFromKeys(keys)).update(json);
  }

  @override
  Future<Map<String, dynamic>?> getDoc(List<String> keys) async {
    try {
      DocumentSnapshot d = (await _getDoc(keys)!.get());
      return d.data() as Map<String, dynamic>?;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<List<Map<String, dynamic>>?> getCollection(List<String> keys) async {
    QuerySnapshot<Map<String, dynamic>?> snapshot =
        (await _getCollection(keys)!.get());
    return snapshot.docs
        .where((d) => d.data() != null)
        .map((d) => d.data()!)
        .toList();
  }

  DocumentReference<Map<String, dynamic>>? _getDoc(List<String> keys) {
    if (checkKeysForNull(keys) == false) return null;
    return firestore.doc(getPathFromKeys(keys));
  }

  CollectionReference<Map<String, dynamic>>? _getCollection(List<String> keys) {
    if (checkKeysForNull(keys) == false) return null;
    return firestore.collection(getPathFromKeys(keys));
  }

  @override
  bool isSignedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  @override
  Future<String?> displayName() {
    return Future.value(FirebaseAuth.instance.currentUser?.displayName);
  }

  @override
  Future<String?> idToken() {
    return FirebaseAuth.instance.currentUser?.getIdToken() ??
        Future.value(null);
  }

  @override
  Stream<bool> signInStatusStream() {
    return FirebaseAuth.instance
        .authStateChanges()
        .map((event) => event != null)
        .asBroadcastStream();
  }

  @override
  Future<bool> signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  @override
  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> updateDisplayName(String newDisplayName) {
    return FirebaseAuth.instance.currentUser
            ?.updateDisplayName(newDisplayName) ??
        Future.value();
  }

  @override
  Future<List<CommunityChallengeData>?> getCommunityChallenges(
      {required Sorting sortBy, required int limit}) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('challenges')
        .orderBy(sortBy.fieldName, descending: sortBy != Sorting.byName)
        .limit(50)
        .get();

    return snapshot.docs
        .map<CommunityChallengeData>((DocumentSnapshot snapshot) {
      return CommunityChallengeData(
          uid: snapshot.id,
          challengeData: ChallengeData.fromJson(
              jsonDecode(snapshot.get('challenge_data'))),
          likes: snapshot.get('likes'),
          author: snapshot.get('author_name'),
          name: snapshot.get('name'),
          date: snapshot.get('date').toDate());
    }).toList();
  }

  @override
  Future<List<CommunityPuzzleData>?> getCommunityPuzzles(
      {required Sorting sortBy, required int limit}) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('puzzles')
        .orderBy(sortBy.fieldName, descending: sortBy != Sorting.byName)
        .limit(50)
        .get();

    return snapshot.docs.map<CommunityPuzzleData>((DocumentSnapshot snapshot) {
      return CommunityPuzzleData(
          uid: snapshot.id,
          puzzleData:
              PuzzleData.fromJson(jsonDecode(snapshot.get('puzzle_data'))),
          likes: snapshot.get('likes'),
          author: snapshot.get('author_name'),
          name: snapshot.get('name'),
          date: snapshot.get('date').toDate());
    }).toList();
  }

  @override
  Future<CommunityPuzzleData> getCommunityPuzzle(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.doc('puzzles/$id').get();
    return CommunityPuzzleData(
        uid: snapshot.id,
        puzzleData:
            PuzzleData.fromJson(jsonDecode(snapshot.get('puzzle_data'))),
        likes: snapshot.get('likes'),
        author: snapshot.get('author_name'),
        name: snapshot.get('name'),
        date: snapshot.get('date').toDate());
  }

  @override
  Future<CommunityChallengeData> getCommunityChallenge(String id) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('challenges').doc(id).get();

    return CommunityChallengeData(
        uid: snapshot.id,
        challengeData:
            ChallengeData.fromJson(jsonDecode(snapshot.get('challenge_data'))),
        likes: snapshot.get('likes'),
        author: snapshot.get('author_name'),
        name: snapshot.get('name'),
        date: snapshot.get('date').toDate());
  }

  @override
  Future<int?> getFeatureRequestThumbsUp(String id) async {
    final DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('feature_requests')
        .doc(id)
        .get();

    return document['thumbs_up'];
  }

  @override
  Future<void> incrementFeatureRequestThumbsUp(String id) {
    final DocumentReference postRef =
        FirebaseFirestore.instance.doc('feature_requests/$id');
    return postRef.update({'thumbs_up': FieldValue.increment(1)});
  }

  @override
  Future<int?> getCommunityStar(String path) async {
    final DocumentSnapshot document =
        await FirebaseFirestore.instance.doc(path).get();

    return document['likes'];
  }

  @override
  Future<void> incrementCommunityStar(String path) {
    final DocumentReference postRef = FirebaseFirestore.instance.doc(path);
    return postRef.update({'likes': FieldValue.increment(1)});
  }

  @override
  Future<List<Map<String, dynamic>>?> getNews(String languageCode) async {
    final List<Map<String, dynamic>>? rawNews =
        await getCollection(['articles_$languageCode']);
    rawNews?.forEach((element) {
      element['date'] = element['date'].toDate();
    });
    return rawNews?.toList();
  }
}
