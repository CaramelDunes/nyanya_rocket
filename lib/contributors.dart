import 'package:flutter/material.dart';

class Contributors extends StatelessWidget {
  static const List<String> _list = const [
    'CaramelDunes',
    'brouxco', // Early testing
    'GuilloteauQ', // Early testing
    'chauvean', // Discovered null shared pref bug
    'Savony', // German translation
  ];

  @override
  Widget build(BuildContext context) {
    return Text(_list.join('\n'));
  }
}
