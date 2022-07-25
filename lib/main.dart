import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'firebase_options.dart';
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

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
