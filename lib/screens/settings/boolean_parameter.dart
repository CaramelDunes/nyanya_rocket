import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BooleanParameter with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  final String key;

  bool _enabled;

  BooleanParameter(
      {@required this.sharedPreferences,
      @required this.key,
      @required bool defaultValue}) {
    enabled = sharedPreferences.getBool(key) ?? defaultValue;
  }

  bool get enabled => _enabled;

  set enabled(bool value) {
    if (_enabled != value) {
      _enabled = value;
      notifyListeners();
    }

    sharedPreferences.setBool(key, value);
  }
}
