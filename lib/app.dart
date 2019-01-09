import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/home/home.dart';

class App extends StatelessWidget {
  static ThemeData darkTheme = ThemeData(
    // Define the default Brightness and Colors
    brightness: Brightness.dark,
    primaryColor: Color(0xFF4842C0),
    accentColor: Colors.white,

    // Define the default Font Family
    fontFamily: 'Roboto',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  );

  static ThemeData brightTheme = ThemeData(
    // Define the default Brightness and Colors
    brightness: Brightness.dark,
    primaryColor: Color(0xFF4842C0),
    accentColor: Colors.cyan[600],

    // Define the default Font Family
    fontFamily: 'Montserrat',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: darkTheme,
      home: Home(),
    );
  }
}
