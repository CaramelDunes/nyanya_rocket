import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/app.dart';

Future<void> main() async {
  // Copied from https://github.com/2d-inc/developer_quest/blob/master/lib/main.dart
  // Don't prune the Flare cache, keep loaded Flare files warm and ready
  // to be re-displayed.
  // FlareCache.doesPrune = false;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}
