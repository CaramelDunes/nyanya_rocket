import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:nyanya_rocket/app.dart';
import 'package:nyanya_rocket/warm_up_flare.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/stores/file_named_data_store.dart';
import 'models/stores/prefs_named_data_store.dart';
import 'models/stores/named_data_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await warmUpFlare();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  if (kIsWeb)
    NamedDataStorage.active = PrefsDataStore(sharedPreferences);
  else
    NamedDataStorage.active = FileNamedDataStorage();

  runApp(App(sharedPreferences: sharedPreferences));
}
