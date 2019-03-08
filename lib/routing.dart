import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/challenges/challenges.dart';
import 'package:nyanya_rocket/screens/multiplayer/multiplayer.dart';
import 'package:nyanya_rocket/screens/puzzles/puzzles.dart';
import 'package:nyanya_rocket/screens/editor/editor.dart';
import 'package:nyanya_rocket/screens/home/home.dart';
import 'package:nyanya_rocket/screens/settings/settings.dart';
import 'package:nyanya_rocket/screens/tutorial/tutorial.dart';

class Routing {
  static final String initialRoute = '/';
  static final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    '/': (BuildContext context) => Home(),
    '/puzzles': (BuildContext context) => Puzzles(),
    '/challenges': (BuildContext context) => Challenges(),
    '/multiplayer': (BuildContext context) => Multiplayer(),
    '/editor': (BuildContext context) => Editor(),
    '/tutorial': (BuildContext context) => Tutorial(),
    '/settings': (BuildContext context) => Settings(),
  };
}
