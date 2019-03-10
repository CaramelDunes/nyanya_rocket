import 'package:flutter/material.dart';

class Options {
  Options({
    @required this.playSounds,
    @required this.darkTheme,
    @required this.animations,
    @required this.language,
  });

  final bool playSounds;
  final bool darkTheme;
  final bool animations;
  final String language;

  Options copyWith(
      {bool playSounds, bool darkTheme, bool animations, String language}) {
    return Options(
        playSounds: playSounds ?? this.playSounds,
        darkTheme: darkTheme ?? this.darkTheme,
        animations: animations ?? this.animations,
        language: language ?? this.language);
  }

  @override
  bool operator ==(dynamic other) {
    return runtimeType == other.runtimeType &&
        playSounds == other.playSounds &&
        darkTheme == other.darkTheme &&
        animations == other.animations &&
        language == other.language;
  }

  @override
  int get hashCode => hashValues(playSounds, darkTheme, animations, language);
}
