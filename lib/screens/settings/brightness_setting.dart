import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../localization/nyanya_localizations.dart';

extension BrightnessToPrettyString on Brightness {
  String toLocalizedString(BuildContext context) {
    switch (this) {
      case Brightness.dark:
        return NyaNyaLocalizations.of(context).themeModeDarkLabel;
      case Brightness.light:
        return NyaNyaLocalizations.of(context).themeModeLightLabel;
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
    return 'Auto (${MediaQuery.of(context).platformBrightness.toLocalizedString(context)})';
  }
}
