import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Regions { auto, usEast, euWest }

class Region with ChangeNotifier {
  static String key = 'options.regionIndex';

  static const Map<Regions, String> _masterServers = {
    Regions.usEast: 'nyanya-us-east.carameldunes.fr',
    Regions.euWest: 'nyanya-eu-west.carameldunes.fr'
  };

  SharedPreferences _prefs;
  Regions _value;

  Region(this._value);

  set prefs(SharedPreferences prefs) {
    _prefs = prefs;

    value = Regions.values[prefs.getInt(key) ?? _value.index];
  }

  Regions get value => _value;

  set value(Regions value) {
    if (value != _value) {
      _value = value;
      notifyListeners();
    }

    if (_prefs != null) _prefs.setInt(key, _value.index);
  }

  String get masterServerHostname =>
      _masterServers[_value == Regions.auto ? automaticValue() : _value];

  static Regions automaticValue() {
    Duration timezoneOffset = DateTime.now().timeZoneOffset;

    if (timezoneOffset <= Duration(hours: -3) ||
        timezoneOffset >= Duration(hours: 11)) {
      return Regions.usEast;
    } else {
      return Regions.euWest;
    }
  }
}
