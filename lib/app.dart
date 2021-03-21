import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nyanya_rocket/screens/challenges/challenge_progression_manager.dart';
import 'package:nyanya_rocket/screens/puzzles/puzzle_progression_manager.dart';
import 'package:nyanya_rocket/services/firebase/firebase_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'routing/nyanya_route_information_parser.dart';
import 'routing/nyanya_router_delegate.dart';
import 'models/user.dart';
import 'screens/settings/dark_mode.dart';
import 'screens/settings/first_run.dart';
import 'screens/settings/language.dart';
import 'screens/settings/region.dart';

class App extends StatefulWidget {
  static const List<Locale> supportedLocales = [
    const Locale('en', ''),
    const Locale('fr', ''),
    const Locale('de', ''),
  ];

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple,
    accentColor: Colors.orangeAccent,
    dividerTheme: DividerThemeData().copyWith(space: 8.0),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.deepPurple,
    accentColor: Colors.orangeAccent,
    dividerTheme: DividerThemeData().copyWith(space: 8.0),
  );

  final SharedPreferences sharedPreferences;

  const App({Key? key, required this.sharedPreferences}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final FirebaseService firebaseService = FirebaseFactory.create();
  late final User _user = User(firebaseService);
  NyaNyaRouterDelegate _routerDelegate = NyaNyaRouterDelegate();
  NyaNyaRouteInformationParser _routeInformationParser =
      NyaNyaRouteInformationParser();

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
                defaultValue: Regions.auto)),
        ChangeNotifierProvider(
            create: (_) => PuzzleProgressionManager(widget.sharedPreferences)),
        ChangeNotifierProvider(
            create: (_) =>
                ChallengeProgressionManager(widget.sharedPreferences)),
        Provider.value(value: firebaseService)
      ],
      child: Consumer2<DarkMode, Language>(
        builder: (_, darkMode, language, __) {
          return MaterialApp.router(
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
            routerDelegate: _routerDelegate,
            routeInformationParser: _routeInformationParser,
          );
        },
      ),
    );
  }
}
