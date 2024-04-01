import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_size/window_size.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'models/stores/file_named_data_store.dart';
import 'models/stores/prefs_named_data_store.dart';
import 'models/stores/named_data_store.dart';
import 'services/firestore/firestore_service.dart';
import 'warm_up_flare.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    setWindowMinSize(const Size(512, 512));
  }

  await warmUpFlare();

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  final isFirebaseSupported =
      !(defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux);

  if (isFirebaseSupported) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    NamedDataStorage.active = PrefsDataStore(sharedPreferences);
  } else {
    NamedDataStorage.active = FileNamedDataStorage();
  }

  runApp(App(
    sharedPreferences: sharedPreferences,
    firestoreService:
        isFirebaseSupported ? await FirestoreFactory.create() : null,
  ));
}
