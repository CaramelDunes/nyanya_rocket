import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/app.dart';
import 'package:nyanya_rocket/warm_up_flare.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await warmUpFlare();
  runApp(App(sharedPreferences: await SharedPreferences.getInstance()));
}
