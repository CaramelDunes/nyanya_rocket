import 'package:firedart/firedart.dart';
import 'package:firedart/firestore/models.dart';

import 'firebase_service.dart';

class FiredartFirebaseService extends FirebaseService {
  FiredartFirebaseService({required this.apiKey, required this.projectId});

  final String apiKey;
  final String projectId;

  Firestore get firestore => Firestore.instance;

  Future<void> init() async {
    Firestore.initialize(projectId);
    FirebaseAuth.initialize(apiKey, VolatileStore());
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
}
