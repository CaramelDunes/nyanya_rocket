import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Regions { auto, usEast, euWest }
enum ComputedRegions { usEast, euWest }

extension ComputeRegion on Regions {
  compute(ComputedRegions automaticValue) {
    switch (this) {
      case Regions.auto:
        return automaticValue;
      case Regions.usEast:
        return ComputedRegions.usEast;
      case Regions.euWest:
        return ComputedRegions.euWest;
    }
  }
}

extension RegionLabel on ComputedRegions {
  String get label {
    switch (this) {
      case ComputedRegions.usEast:
        return 'US East';
      case ComputedRegions.euWest:
        return 'Europe West';
    }
  }
}

class Region with ChangeNotifier {
  static String key = 'options.regionIndex';
  final SharedPreferences sharedPreferences;
  Regions _value;

  Region({required Regions defaultValue, required this.sharedPreferences})
      : _value =
            Regions.values[sharedPreferences.getInt(key) ?? defaultValue.index];

  Regions get value => _value;

  ComputedRegions get computedValue => _value.compute(automaticValue());

  String get label => computedValue.label;

  set value(Regions value) {
    if (value != _value) {
      _value = value;
      notifyListeners();
    }

    sharedPreferences.setInt(key, _value.index);
  }

  String get masterServerHostname {
    switch (computedValue) {
      case ComputedRegions.usEast:
        return 'nyanya-us-east.carameldunes.fr';
      case ComputedRegions.euWest:
        return 'nyanya-eu-west.carameldunes.fr';
    }
  }

  static ComputedRegions automaticValue() {
    Duration timezoneOffset = DateTime.now().timeZoneOffset;

    if (timezoneOffset <= Duration(hours: -3) ||
        timezoneOffset >= Duration(hours: 11)) {
      return ComputedRegions.usEast;
    } else {
      return ComputedRegions.euWest;
    }
  }
}
