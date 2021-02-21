import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Language with ChangeNotifier {
  static String key = 'options.language';

  final SharedPreferences sharedPreferences;
  String _value;

  Language({required String defaultValue, required this.sharedPreferences})
      : _value = sharedPreferences.getString(key) ?? defaultValue;

  String get value => _value;

  set value(String value) {
    if (value != _value) {
      _value = value;
      notifyListeners();
    }

    sharedPreferences.setString(key, _value);
  }
}
