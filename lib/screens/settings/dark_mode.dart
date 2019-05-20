import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkMode with ChangeNotifier {
  static String key = 'options.darkTheme';

  SharedPreferences _prefs;
  bool _enabled;

  DarkMode(this._enabled);

  set prefs(SharedPreferences prefs) {
    _prefs = prefs;

    enabled = prefs.getBool(key);
  }

  bool get enabled => _enabled;

  set enabled(bool value) {
    if (_enabled != value) {
      _enabled = value;
      notifyListeners();

      if (_prefs != null) _prefs.setBool(key, value);
    }
  }
}
