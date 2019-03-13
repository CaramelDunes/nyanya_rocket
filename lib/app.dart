import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations_delegate.dart';
import 'package:nyanya_rocket/models/options.dart';
import 'package:nyanya_rocket/options_holder.dart';
import 'package:nyanya_rocket/routing.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return OptionsHolder(
      optionWidgetBuilder: (BuildContext context, Options options) =>
          MaterialApp(
              localizationsDelegates: [
                const NyaNyaLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: supportedLocales,
              locale:
                  options.language == 'auto' ? null : Locale(options.language),
              title: 'NyaNya Rocket!',
              theme: options.darkTheme ? darkTheme : lightTheme,
              initialRoute: Routing.initialRoute,
              routes: Routing.routes),
    );
  }
}
