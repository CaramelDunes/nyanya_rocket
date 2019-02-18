import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/challenges/challenges.dart';
import 'package:nyanya_rocket/screens/multiplayer/multiplayer.dart';
import 'package:nyanya_rocket/screens/puzzles/puzzles.dart';
import 'package:nyanya_rocket/screens/editor/editor.dart';
import 'package:nyanya_rocket/screens/home/home.dart';
import 'package:nyanya_rocket/screens/settings/settings.dart';

class Routing {
  static final String initialRoute = '/';
  static final Map<String, WidgetBuilder> routes =  <String, WidgetBuilder>{
    '/': (BuildContext context) => new Home(),
    '/puzzles': (BuildContext context) => new Puzzles(),
    '/challenges': (BuildContext context) => new Challenges(),
    '/multiplayer': (BuildContext context) => new Multiplayer(),
    '/editor': (BuildContext context) => new Editor(),
    '/settings': (BuildContext context) => new Settings(),
  };
}