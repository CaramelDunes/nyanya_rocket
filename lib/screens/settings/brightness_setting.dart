import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension BrightnessToPrettyString on Brightness {
  String toPrettyString() {
    switch (this) {
      case Brightness.dark:
        return 'Dark';
      case Brightness.light:
        return 'Light';
    }
  }
}

class BrightnessSetting with ChangeNotifier {
  static String key = 'options.brightness';
  final SharedPreferences sharedPreferences;
  ThemeMode _value;

  BrightnessSetting(
      {required ThemeMode defaultValue, required this.sharedPreferences})
      : _value = ThemeMode
            .values[sharedPreferences.getInt(key) ?? defaultValue.index];

  ThemeMode get value => _value;

  set value(ThemeMode value) {
    if (value != _value) {
      _value = value;
      notifyListeners();
    }

    sharedPreferences.setInt(key, _value.index);
  }

  static String automaticValueLabel(BuildContext context) {
    return 'Auto (${MediaQuery.of(context).platformBrightness.toPrettyString()})';
  }
}
