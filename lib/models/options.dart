import 'package:flutter/material.dart';

class Options {
  Options({
    this.playSounds,
    this.darkTheme,
  });

  final bool playSounds;
  final bool darkTheme;

  Options copyWith({
    bool playSounds,
    bool darkTheme,
  }) {
    return Options(
      playSounds: playSounds ?? this.playSounds,
      darkTheme: darkTheme ?? this.darkTheme,
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) return false;
    return playSounds == other.playSounds && darkTheme == other.darkTheme;
  }

  @override
  int get hashCode => hashValues(
        playSounds,
        darkTheme,
      );
}
