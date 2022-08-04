import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'routing/nyanya_route_information_parser.dart';
import 'routing/nyanya_router_delegate.dart';
import 'models/user.dart';
import 'screens/challenges/challenge_progression_manager.dart';
import 'screens/challenges/tabs/original_challenges.dart';
import 'screens/puzzles/puzzle_progression_manager.dart';
import 'screens/puzzles/widgets/original_puzzles.dart';
import 'screens/settings/brightness_setting.dart';
import 'screens/settings/first_run.dart';
import 'screens/settings/language.dart';
import 'screens/settings/region.dart';
import 'services/firestore/firestore_service.dart';

class App extends StatefulWidget {
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('fr'),
    Locale('de'),
  ];

  static final ThemeData lightTheme = ThemeData.from(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
        primary: Colors.deepPurple, secondary: Colors.orangeAccent),
  );

  static final ThemeData darkTheme = ThemeData.from(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
        primary: Colors.orange, secondary: Colors.deepPurpleAccent),
  );

  final SharedPreferences sharedPreferences;
  final FirestoreService firestoreService;

  const App(
      {super.key,
      required this.sharedPreferences,
      required this.firestoreService});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final User _user = User(auth.FirebaseAuth.instance);
  final NyaNyaRouterDelegate _routerDelegate = NyaNyaRouterDelegate();
  final NyaNyaRouteInformationParser _routeInformationParser =
      NyaNyaRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _user),
        ChangeNotifierProvider(
            create: (_) => BrightnessSetting(
                defaultValue: ThemeMode.system,
                sharedPreferences: widget.sharedPreferences)),
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
            create: (_) => PuzzleProgressionManager(
                sharedPreferences: widget.sharedPreferences,
                numberOfPuzzles: OriginalPuzzles.jsons.length)),
        ChangeNotifierProvider(
            create: (_) => ChallengeProgressionManager(
                sharedPreferences: widget.sharedPreferences,
                numberOfChallenges: OriginalChallenges.challenges.length)),
        Provider.value(value: widget.firestoreService)
      ],
      child: Consumer2<BrightnessSetting, Language>(
        builder: (_, darkMode, language, __) {
          return MaterialApp.router(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              ...GlobalMaterialLocalizations.delegates,
            ],
            supportedLocales: App.supportedLocales,
            locale: language.value == 'auto' ? null : Locale(language.value),
            title: 'NyaNya Rocket!',
            themeMode: darkMode.value,
            theme: App.lightTheme,
            darkTheme: App.darkTheme,
            routerDelegate: _routerDelegate,
            routeInformationParser: _routeInformationParser,
          );
        },
      ),
    );
  }
}
