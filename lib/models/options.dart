import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Options {
  Options(
      {@required this.playSounds,
      @required this.darkTheme,
      @required this.animations,
      @required this.language,
      @required this.firstRun});

  final bool playSounds;
  final bool darkTheme;
  final bool animations;
  final String language;
  final bool firstRun;

  Options copyWith(
      {bool playSounds,
      bool darkTheme,
      bool animations,
      String language,
      bool firstRun}) {
    return Options(
        playSounds: playSounds ?? this.playSounds,
        darkTheme: darkTheme ?? this.darkTheme,
        animations: animations ?? this.animations,
        language: language ?? this.language,
        firstRun: firstRun ?? this.firstRun);
  }

  Options.fromSharedPrefs(SharedPreferences prefs)
      : playSounds = prefs.getBool('options.playSounds') ?? true,
        darkTheme = prefs.getBool('options.darkTheme') ?? false,
        animations = prefs.getBool('options.animations') ?? true,
        language = prefs.getString('options.language') ?? 'auto',
        firstRun = prefs.getBool('options.firstRun') ?? true;

  Future<void> toSharedPrefs(SharedPreferences prefs) async {
    await prefs.setBool('options.playSounds', playSounds);
    await prefs.setBool('options.darkTheme', darkTheme);
    await prefs.setBool('options.animations', animations);
    await prefs.setString('options.language', language);
    await prefs.setBool('options.firstRun', firstRun);
  }

  @override
  bool operator ==(dynamic other) {
    return runtimeType == other.runtimeType &&
        playSounds == other.playSounds &&
        darkTheme == other.darkTheme &&
        animations == other.animations &&
        language == other.language &&
        firstRun == other.firstRun;
  }

  @override
  int get hashCode =>
      hashValues(playSounds, darkTheme, animations, language, firstRun);
}
