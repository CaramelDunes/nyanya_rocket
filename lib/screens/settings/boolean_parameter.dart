import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BooleanParameter with ChangeNotifier {
  final String key;

  SharedPreferences _prefs;
  bool _enabled;

  BooleanParameter({this.key, bool defaultValue}) : _enabled = defaultValue;

  set prefs(SharedPreferences prefs) {
    _prefs = prefs;

    enabled = prefs.getBool(key) ?? _enabled;
  }

  bool get enabled => _enabled;

  set enabled(bool value) {
    if (_enabled != value) {
      _enabled = value;
      notifyListeners();
    }

    if (_prefs != null) _prefs.setBool(key, value);
  }
}
