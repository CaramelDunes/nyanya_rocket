import 'package:flutter/material.dart';

class Contributors extends StatelessWidget {
  static const List<String> _list = [
    'CaramelDunes',
    'brouxco', // Early testing
    'GuilloteauQ', // Early testing
    'chauvean', // Discovered null shared pref bug
    'Savony', // German translation
    'Dread', // Out of sync puzzle controls
    '424242', // Night mode multiplayer clock display bug
    'ln(√π)', // Thumbs-up master clicker
  ];

  const Contributors({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(_list.join('\n'));
  }
}
