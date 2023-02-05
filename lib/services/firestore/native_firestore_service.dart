import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:nyanya_rocket/screens/challenges/community_challenge_data.dart';
import 'package:nyanya_rocket/screens/puzzles/community_puzzle_data.dart';

import 'firestore_service.dart';

class NativeFirestoreService extends FirestoreService {
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @override
  Future<void> init() async {
    // Initialized in main.
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
      debugPrint("Add Doc ${getPathFromKeys(keys)}");
      await firestore
          .doc(getPathFromKeys(keys, addUserPath: addUserPath))
          .set(json);
      debugPrint("Add Doc Complete");
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
      debugPrint(e.toString());
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
  Future<List<Map<String, dynamic>>> getNews(String languageCode) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('articles_$languageCode')
        .orderBy('date', descending: true)
        .limit(15)
        .get();

    return snapshot.docs.map((e) => e.data()).toList();
  }
}
