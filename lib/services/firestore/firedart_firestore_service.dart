import 'dart:convert';

import 'package:firedart/firedart.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:nyanya_rocket/screens/challenges/community_challenge_data.dart';
import 'package:nyanya_rocket/screens/puzzles/community_puzzle_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firestore_service.dart';

class FiredartFirebaseService extends FirestoreService {
  FiredartFirebaseService({required this.apiKey, required this.projectId});

  final String apiKey;
  final String projectId;

  Firestore get firestore => Firestore.instance;

  @override
  Future<void> init() async {
    Firestore.initialize(projectId);
  }

  @override
  Future<Map<String, dynamic>?> getDoc(List<String> keys) async {
    //print("getDocData: ${keys.toString()}");
    try {
      Document d = (await _getDoc(keys)!.get());
      return d.map..['documentId'] = d.id;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<List<Map<String, dynamic>>> getCollection(List<String> keys) async {
    //print("getDocStream: ${keys.toString()}");
    Page<Document> docs = (await _getCollection(keys)!.get());
    for (Document d in docs) {
      d.map['documentId'] = d.id;
    }
    return docs.map((d) => d.map).toList();
  }

  @override
  Stream<Map<String, dynamic>> getDocStream(List<String> keys) {
    //print("getDocStream: ${keys.toString()}");
    return _getDoc(keys)!.stream.map((d) => d!.map..['documentId'] = d.id);
  }

  @override
  Stream<List<Map<String, dynamic>>> getListStream(List<String> keys) {
    //print("getListStream: ${keys.toString()}");
    return _getCollection(keys)!.stream.map(
      (List<Document> docs) {
        return (docs).map((d) => d.map..['documentId'] = d.id).toList();
      },
    );
  }

  @override
  Future<String> addDoc(List<String> keys, Map<String, dynamic> json,
      {String? documentId, bool addUserPath = true}) async {
    if (documentId != null) {
      keys.add(documentId);
      //safePrint("Add Doc ${getPathFromKeys(keys)}");
      await firestore
          .document(getPathFromKeys(keys, addUserPath: addUserPath))
          .update(json);
      //safePrint("Add Doc Complete");
      return documentId;
    }
    CollectionReference ref =
        firestore.collection(getPathFromKeys(keys, addUserPath: addUserPath));
    final doc = await ref.add(json);
    return (doc).id;
  }

  @override
  Future<void> deleteDoc(List<String> keys) async {
    await firestore
        .document(getPathFromKeys(keys))
        .delete()
        .catchError((Object e) {
      print(e);
    });
  }

  @override
  Future<void> updateDoc(List<String> keys, Map<String, dynamic> json,
      [bool update = false]) async {
    await firestore.document(getPathFromKeys(keys)).update(json);
  }

  DocumentReference? _getDoc(List<String> keys) {
    if (checkKeysForNull(keys) == false) return null;
    DocumentReference docRef = firestore.document(getPathFromKeys(keys));
    //print("getDoc: " + docRef.path);
    return docRef;
  }

  CollectionReference? _getCollection(List<String> keys) {
    if (checkKeysForNull(keys) == false) return null;
    final colRef = firestore.collection(getPathFromKeys(keys));
    //print("Got path: " + colRef.path);
    return colRef;
  }

  @override
  Future<List<CommunityChallengeData>?> getCommunityChallenges(
      {required Sorting sortBy, required int limit}) async {
    final snapshot = await Firestore.instance
        .collection('challenges')
        .orderBy(sortBy.fieldName, descending: sortBy != Sorting.byName)
        .limit(50)
        .get();

    return snapshot.map<CommunityChallengeData>((Document snapshot) {
      return CommunityChallengeData(
          uid: snapshot.id,
          challengeData:
              ChallengeData.fromJson(jsonDecode(snapshot['challenge_data'])),
          likes: snapshot['likes'],
          author: snapshot['author_name'],
          name: snapshot['name'],
          date: snapshot['date']);
    }).toList();
  }

  @override
  Future<List<CommunityPuzzleData>?> getCommunityPuzzles(
      {required Sorting sortBy, required int limit}) async {
    final snapshot = await Firestore.instance
        .collection('puzzles')
        .orderBy(sortBy.fieldName, descending: sortBy != Sorting.byName)
        .limit(50)
        .get();

    return snapshot.map<CommunityPuzzleData>((Document snapshot) {
      return CommunityPuzzleData(
          uid: snapshot.id,
          puzzleData: PuzzleData.fromJson(jsonDecode(snapshot['puzzle_data'])),
          likes: snapshot['likes'],
          author: snapshot['author_name'],
          name: snapshot['name'],
          date: snapshot['date']);
    }).toList();
  }

  @override
  Future<CommunityPuzzleData> getCommunityPuzzle(String id) async {
    final snapshot = await Firestore.instance.document('puzzles/$id').get();

    return CommunityPuzzleData(
        uid: snapshot.id,
        puzzleData: PuzzleData.fromJson(jsonDecode(snapshot['puzzle_data'])),
        likes: snapshot['likes'],
        author: snapshot['author_name'],
        name: snapshot['name'],
        date: snapshot['date']);
  }

  @override
  Future<CommunityChallengeData> getCommunityChallenge(String id) async {
    final snapshot = await Firestore.instance.document('challenges/$id').get();

    return CommunityChallengeData(
        uid: snapshot.id,
        challengeData:
            ChallengeData.fromJson(jsonDecode(snapshot['challenge_data'])),
        likes: snapshot['likes'],
        author: snapshot['author_name'],
        name: snapshot['name'],
        date: snapshot['date']);
  }

  @override
  Future<int?> getFeatureRequestThumbsUp(String id) async {
    final snapshot =
        await Firestore.instance.document('feature_requests/$id').get();
    return snapshot['thumbs_up'];
  }

  @override
  Future<void> incrementFeatureRequestThumbsUp(String id) async {
    final currentValue = await getFeatureRequestThumbsUp(id);

    if (currentValue != null) {
      return Firestore.instance
          .document('feature_requests/$id')
          .update({'thumbs_up': currentValue + 1});
    }
    // FIXME Use 'atomic' increment once available.
  }

  @override
  Future<int?> getCommunityStar(String path) async {
    final snapshot = await Firestore.instance.document(path).get();
    return snapshot['likes'];
  }

  @override
  Future<void> incrementCommunityStar(String path) async {
    final currentValue = await getCommunityStar(path);

    if (currentValue != null) {
      return Firestore.instance
          .document(path)
          .update({'likes': currentValue + 1});
    }
    // FIXME Use 'atomic' increment when available.
  }

  @override
  Future<List<Map<String, dynamic>>> getNews(String languageCode) {
    return getCollection(['articles_$languageCode']);
  }
}
