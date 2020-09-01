import 'package:firebase_core/firebase_core.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // Copied from https://github.com/2d-inc/developer_quest/blob/master/lib/main.dart
  // Don't prune the Flare cache, keep loaded Flare files warm and ready
  // to be re-displayed.
  FlareCache.doesPrune = false;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App(sharedPreferences: await SharedPreferences.getInstance()));
}
