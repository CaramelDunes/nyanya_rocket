import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/options.dart';
import 'package:nyanya_rocket/options_holder.dart';
import 'package:nyanya_rocket/routing.dart';

class App extends StatelessWidget {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.orange,
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
              title: 'NyaNya Rocket!',
              theme: options.darkTheme ? darkTheme : lightTheme,
              initialRoute: Routing.initialRoute,
              routes: Routing.routes),
    );
  }
}
