import 'dart:collection';

import 'package:nyanya_rocket/screens/puzzles/widgets/original_puzzles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PuzzleProgressionManager {
  static final Future<SharedPreferences> prefs =
      SharedPreferences.getInstance();

  static String _clearedKeyOf(int i) => "puzzle.original.$i.cleared";

  static String _starredKeyOf(int i) => "puzzle.original.$i.starred";

  static Future<SplayTreeSet<int>> getCleared() async {
    SharedPreferences prefs = await PuzzleProgressionManager.prefs;
    SplayTreeSet<int> cleared = SplayTreeSet();

    for (int i = 0; i < OriginalPuzzles.puzzles.length; i += 1) {
      if (prefs.getBool(_clearedKeyOf(i)) ?? false) {
        cleared.add(i);
      }
    }
    return cleared;
  }

  static Future<SplayTreeSet<int>> getStarred() async {
    SharedPreferences prefs = await PuzzleProgressionManager.prefs;
    SplayTreeSet<int> starred = SplayTreeSet();

    for (int i = 0; i < OriginalPuzzles.puzzles.length; i += 1) {
      if (prefs.getBool(_starredKeyOf(i)) ?? false) {
        starred.add(i);
      }
    }
    return starred;
  }

  static Future<void> setCleared(int i, [bool cleared = true]) async {
    SharedPreferences prefs = await PuzzleProgressionManager.prefs;
    return prefs.setBool(_clearedKeyOf(i), cleared).then((bool _) {});
  }

  static Future<void> setStarred(int i, [bool starred = true]) async {
    SharedPreferences prefs = await PuzzleProgressionManager.prefs;
    return prefs.setBool(_starredKeyOf(i), starred).then((bool _) {});
  }
}
