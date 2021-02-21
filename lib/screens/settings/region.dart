import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Regions { auto, usEast, euWest }

class Region with ChangeNotifier {
  static String key = 'options.regionIndex';

  static const Map<Regions, String> _masterServers = {
    Regions.usEast: 'nyanya-us-east.carameldunes.fr',
    Regions.euWest: 'nyanya-eu-west.carameldunes.fr'
  };

  static const Map<Regions, String> regionLabels = {
    Regions.usEast: 'US East',
    Regions.euWest: 'Europe West'
  };

  final SharedPreferences sharedPreferences;
  Regions _value;

  Region({required Regions defaultValue, required this.sharedPreferences})
      : _value =
            Regions.values[sharedPreferences.getInt(key) ?? defaultValue.index];

  Regions get value => _value;

  Regions get computedValue =>
      _value == Regions.auto ? automaticValue() : _value;

  String get label => regionLabels[computedValue]!; // FIXME Maybe

  set value(Regions value) {
    if (value != _value) {
      _value = value;
      notifyListeners();
    }

    sharedPreferences.setInt(key, _value.index);
  }

  String get masterServerHostname =>
      _masterServers[computedValue]!; // FIXME Maybe

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
