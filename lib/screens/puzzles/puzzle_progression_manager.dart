import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PuzzleProgressionManager with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  final int numberOfPuzzles;
  final Set<int> _cleared = {};
  final Set<int> _starred = {};

  PuzzleProgressionManager(
      {required this.sharedPreferences, required this.numberOfPuzzles}) {
    _readFromSharedPreferences();
  }

  String _clearedKeyOf(int i) => "puzzle.original.$i.cleared";

  String _starredKeyOf(int i) => "puzzle.original.$i.starred";

  void _readFromSharedPreferences() {
    for (int i = 0; i < numberOfPuzzles; i += 1) {
      if (sharedPreferences.getBool(_clearedKeyOf(i)) ?? false) {
        _cleared.add(i);
      }

      if (sharedPreferences.getBool(_starredKeyOf(i)) ?? false) {
        _starred.add(i);
      }
    }
  }

  Set<int> getCleared() {
    return _cleared;
  }

  Set<int> getStarred() {
    return _starred;
  }

  Future<bool> setCleared(int i, [bool cleared = true]) async {
    _cleared.add(i);
    notifyListeners();
    return sharedPreferences.setBool(_clearedKeyOf(i), cleared);
  }

  Future<bool> setStarred(int i, [bool starred = true]) async {
    _starred.add(i);
    notifyListeners();
    return sharedPreferences.setBool(_starredKeyOf(i), starred);
  }

  bool isPuzzleCleared(int i) {
    return _cleared.contains(i);
  }

  int getFirstNotClearedPuzzle() {
    int i = 0;

    while (isPuzzleCleared(i)) {
      i++;
    }

    return i;
  }

  double get completedRatio {
    return _cleared.length / numberOfPuzzles;
  }
}
