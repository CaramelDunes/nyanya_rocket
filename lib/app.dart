import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations_delegate.dart';
import 'package:nyanya_rocket/models/user.dart';
import 'package:nyanya_rocket/routing.dart';
import 'package:nyanya_rocket/screens/settings/dark_mode.dart';
import 'package:nyanya_rocket/screens/settings/first_run.dart';
import 'package:nyanya_rocket/screens/settings/language.dart';
import 'package:nyanya_rocket/screens/settings/sounds.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  static const String projectUrl =
      'https://github.com/CaramelDunes/nyanya_rocket';
  static const String privacyPolicyUrl =
      'https://carameldunes.fr/NyaNyaPrivacyPolicy.html';

  static const List<Locale> supportedLocales = [
    const Locale('en', 'US'),
    const Locale('fr', 'FR'),
    const Locale('de', 'DE'),
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
  final DarkMode _darkMode = DarkMode();
  final Language _language = Language('auto');
  final FirstRun _firstRun = FirstRun();
  final Sounds _sounds = Sounds();
  final User _user = User();

  @override
  void initState() {
    // Copied from https://github.com/2d-inc/developer_quest/blob/master/lib/main.dart
    // Schedule a micro-task that warms up the image cache with all the
    // board images.
    scheduleMicrotask(() {
      precacheImage(AssetImage('assets/graphics/generator.png'), context);
      precacheImage(AssetImage('assets/graphics/rocket_blue.png'), context);
      precacheImage(AssetImage('assets/graphics/arrow_blue.png'), context);
      precacheImage(AssetImage('assets/graphics/pit.png'), context);
      precacheImage(AssetImage('assets/graphics/arrow_grey.png'), context);
      precacheImage(AssetImage('assets/graphics/departed_rocket.png'), context);
    });

    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      _darkMode.prefs = prefs;
      _language.prefs = prefs;
      _firstRun.prefs = prefs;
      _sounds.prefs = prefs;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(notifier: _darkMode),
        ChangeNotifierProvider.value(notifier: _language),
        // TODO Move this to the What's New tab
        ChangeNotifierProvider.value(notifier: _firstRun),
        ChangeNotifierProvider.value(notifier: _sounds),
        ChangeNotifierProvider.value(notifier: _user),
      ],
      child: Consumer2<DarkMode, Language>(
        builder: (context2, darkMode, language, _) => MaterialApp(
                localizationsDelegates: [
                  const NyaNyaLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: App.supportedLocales,
                locale:
                    language.value == 'auto' ? null : Locale(language.value),
                title: 'NyaNya Rocket!',
                theme: darkMode.enabled ? App.darkTheme : App.lightTheme,
                darkTheme: App.darkTheme,
                initialRoute: Routing.initialRoute,
                routes: Routing.routes),
      ),
    );
  }
}
