import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations_delegate.dart';
import 'package:nyanya_rocket/models/options.dart';
import 'package:nyanya_rocket/options_holder.dart';
import 'package:nyanya_rocket/routing.dart';

class App extends StatefulWidget {
  static const String projectUrl =
      'https://github.com/CaramelDunes/nyanya_rocket';
  static const String privacyPolicyUrl =
      'https://carameldunes.fr/NyaNyaPrivacyPolicy.html';

  static const List<Locale> supportedLocales = [
    const Locale('en', 'US'),
    const Locale('fr', 'FR'),
  ];

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple,
    accentColor: Colors.orangeAccent,
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.deepPurple,
    accentColor: Colors.orangeAccent,
  );

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    // Copied from https://github.com/2d-inc/developer_quest/blob/master/lib/main.dart
    // Schedule a micro-task that warms up the image cache with all the puzzle
    // board images.
    scheduleMicrotask(() {
      precacheImage(AssetImage('assets/graphics/generator.png'), context);
      precacheImage(AssetImage('assets/graphics/rocket_blue.png'), context);
      precacheImage(AssetImage('assets/graphics/arrow_blue.png'), context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OptionsHolder(
      optionWidgetBuilder: (BuildContext context, Options options) =>
          MaterialApp(
              localizationsDelegates: [
                const NyaNyaLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: App.supportedLocales,
              locale:
                  options.language == 'auto' ? null : Locale(options.language),
              title: 'NyaNya Rocket!',
              theme: options.darkTheme ? App.darkTheme : App.lightTheme,
              initialRoute: Routing.initialRoute,
              routes: Routing.routes),
    );
  }
}
