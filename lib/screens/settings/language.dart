import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Language with ChangeNotifier {
  static String key = 'options.language';

  SharedPreferences _prefs;
  String _value;

  Language(this._value);

  set prefs(SharedPreferences prefs) {
    _prefs = prefs;
    
    value = prefs.getString(key);
  }

  String get value => _value;

  set value(String value) {
    if (value != _value) {
      _value = value;
      notifyListeners();

      if (_prefs != null) _prefs.setString(key, _value);
    }
  }
}
