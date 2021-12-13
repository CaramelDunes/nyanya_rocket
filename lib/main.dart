import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'config.dart';
import 'models/stores/file_named_data_store.dart';
import 'models/stores/prefs_named_data_store.dart';
import 'models/stores/named_data_store.dart';
import 'services/firestore/firestore_service.dart';
import 'warm_up_flare.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await warmUpFlare();

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  // When the native plugin in available,
  // Firebase will initialize using the embedded config JSON.
  if (FirestoreFactory.useNative) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: kFirebaseApiKey,
      appId: kFirebaseAppId,
      messagingSenderId: kFirebaseMessagingSenderId,
      projectId: kFirebaseProjectId,
    ));
  }

  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    NamedDataStorage.active = PrefsDataStore(sharedPreferences);
  } else {
    NamedDataStorage.active = FileNamedDataStorage();
  }

  runApp(App(
    sharedPreferences: sharedPreferences,
    firestoreService: await FirestoreFactory.create(),
  ));
}
