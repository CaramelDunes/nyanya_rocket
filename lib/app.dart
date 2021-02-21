import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nyanya_rocket/models/user.dart';
import 'package:nyanya_rocket/routing.dart';
import 'package:nyanya_rocket/screens/settings/dark_mode.dart';
import 'package:nyanya_rocket/screens/settings/first_run.dart';
import 'package:nyanya_rocket/screens/settings/language.dart';
import 'package:nyanya_rocket/screens/settings/region.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatefulWidget {
  static const String projectUrl =
      'https://github.com/CaramelDunes/nyanya_rocket';
  static const String privacyPolicyUrl =
      'https://carameldunes.fr/NyaNyaPrivacyPolicy.html';

  static const List<Locale> supportedLocales = [
    const Locale('en', ''),
    const Locale('fr', ''),
    const Locale('de', ''),
  ];

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.deepPurple,
      accentColor: Colors.orangeAccent,
      dividerTheme: DividerThemeData().copyWith(space: 8.0));

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.deepPurple,
      accentColor: Colors.orangeAccent,
      dividerTheme: DividerThemeData().copyWith(space: 8.0));

  final SharedPreferences sharedPreferences;

  const App({Key? key, required this.sharedPreferences}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final User _user = User();

  @override
  void initState() {
    super.initState();

    // Copied from https://github.com/2d-inc/developer_quest/blob/master/lib/main.dart
    // Schedule a micro-task that warms up the image cache with all the
    // board images.
    scheduleMicrotask(() {
      precacheImage(AssetImage('assets/graphics/generator.png'), context);
      precacheImage(AssetImage('assets/graphics/pit.png'), context);
      precacheImage(AssetImage('assets/graphics/departed_rocket.png'), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _user),
        ChangeNotifierProvider(
            create: (_) =>
                DarkMode(sharedPreferences: (widget.sharedPreferences))),
        ChangeNotifierProvider(
            create: (_) => Language(
                sharedPreferences: widget.sharedPreferences,
                defaultValue: 'auto')),
        // TODO Move this to the What's New tab
        ChangeNotifierProvider(
            create: (_) =>
                FirstRun(sharedPreferences: widget.sharedPreferences)),
        ChangeNotifierProvider(
            create: (_) => Region(
                sharedPreferences: widget.sharedPreferences,
                defaultValue: Regions.auto))
      ],
      child: Consumer2<DarkMode, Language>(
        builder: (_, darkMode, language, __) {
          return MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: App.supportedLocales,
            locale: language.value == 'auto' ? null : Locale(language.value),
            title: 'NyaNya Rocket!',
            theme: darkMode.enabled ? App.darkTheme : App.lightTheme,
            darkTheme: App.darkTheme,
            initialRoute: Routing.initialRoute,
            routes: Routing.routes,
          );
        },
      ),
    );
  }
}
