import 'dart:convert';

import 'package:firedart/firedart.dart';
import 'package:firedart/firestore/models.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/models/puzzle_data.dart';
import 'package:nyanya_rocket/screens/challenges/community_challenge_data.dart';
import 'package:nyanya_rocket/screens/puzzles/community_puzzle_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_service.dart';

class FiredartFirebaseService extends FirebaseService {
  FiredartFirebaseService({required this.apiKey, required this.projectId});

  final String apiKey;
  final String projectId;

  Firestore get firestore => Firestore.instance;

  Future<void> init() async {
    Firestore.initialize(projectId);
    FirebaseAuth.initialize(apiKey, await PreferencesStore.create());
  }

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

  Future<List<Map<String, dynamic>>> getCollection(List<String> keys) async {
    //print("getDocStream: ${keys.toString()}");
    Page<Document> docs = (await _getCollection(keys)!.get());
    docs.forEach((d) {
      d.map..['documentId'] = d.id;
    });
    return docs.map((d) => d.map).toList();
  }

  Stream<Map<String, dynamic>> getDocStream(List<String> keys) {
    //print("getDocStream: ${keys.toString()}");
    return _getDoc(keys)!.stream.map((d) => d!.map..['documentId'] = d.id);
  }

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
  bool isSignedIn() {
    return FirebaseAuth.instance.isSignedIn;
  }

  @override
  Future<String?> displayName() async {
    final user = await FirebaseAuth.instance.getUser();

    return user.displayName;
  }

  @override
  Future<String?> idToken() {
    if (FirebaseAuth.instance.isSignedIn)
      return FirebaseAuth.instance.tokenProvider.idToken;
    else
      return Future.value(null);
  }

  @override
  Stream<bool> signInStatusStream() {
    return FirebaseAuth.instance.signInState.asBroadcastStream();
  }

  @override
  Future<bool> signInAnonymously() async {
    final user = await FirebaseAuth.instance.signInAnonymously();
    return user.id != null;
  }

  @override
  Future<void> signOut() {
    FirebaseAuth.instance.signOut();
    return Future.value();
  }

  @override
  Future<void> updateDisplayName(String newDisplayName) {
    return FirebaseAuth.instance.updateProfile(displayName: newDisplayName);
  }

  @override
  Future<List<CommunityChallengeData>?> getCommunityChallenges(
      {required Sorting sortBy, required int limit}) async {
    final snapshot = await Firestore.instance
        .collection('challenges')
        .orderBy(sortBy.fieldName, descending: sortBy != Sorting.ByName)
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
        .orderBy(sortBy.fieldName, descending: sortBy != Sorting.ByName)
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

    if (currentValue != null)
      return Firestore.instance
          .document('feature_requests/$id')
          .update({'thumbs_up': currentValue + 1});
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

    if (currentValue != null)
      return Firestore.instance
          .document(path)
          .update({'likes': currentValue + 1});
    // FIXME Use 'atomic' increment when available.
  }

  @override
  Future<List<Map<String, dynamic>>> getNews(String languageCode) {
    return getCollection(['articles_$languageCode']);
  }
}

class PreferencesStore extends TokenStore {
  static const keyToken = "auth_token";

  static Future<PreferencesStore> create() async =>
      PreferencesStore._internal(await SharedPreferences.getInstance());

  SharedPreferences _prefs;

  PreferencesStore._internal(this._prefs);

  @override
  Token? read() => _prefs.containsKey(keyToken)
      ? Token.fromMap(
          jsonDecode(_prefs.getString(keyToken)!) as Map<String, dynamic>)
      : null;

  @override
  void write(Token token) {
    _prefs.setString(keyToken, jsonEncode(token.toMap()));
  }

  @override
  void delete() => _prefs.remove(keyToken);
}
