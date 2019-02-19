import 'package:nyanya_rocket/screens/puzzles/widgets/original_puzzles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PuzzleProgressionManager {
  List<bool> _statuses = List.filled(OriginalPuzzles.puzzles.length, false);
  List<bool> _stars = List.filled(OriginalPuzzles.puzzles.length, false);
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static String clearedKeyOf(int i) => "puzzle.original.$i.cleared";
  static String starredKeyOf(int i) => "puzzle.original.$i.starred";

  Future<void> loadStatuses() async {
    SharedPreferences prefs = await this.prefs;

    for (int i = 0; i < _statuses.length; i += 1) {
      _statuses[i] = prefs.getBool(clearedKeyOf(i)) ?? false;

      if (_statuses[i]) {
        _stars[i] = prefs.getBool(starredKeyOf(i)) ?? false;
      }
    }

    return;
  }

  Future<void> _saveStatuses() async {
    SharedPreferences prefs = await this.prefs;

    for (int i = 0; i < _statuses.length; i += 1) {
      prefs.setBool(clearedKeyOf(i), _statuses[i]);

      if (_statuses[i]) {
        prefs.setBool(starredKeyOf(i), _stars[i]);
      }
    }
  }

  bool hasCleared(int i) => _statuses[i];
  bool hasStarred(int i) => _stars[i];

  void setCleared(int i, [bool cleared = true]) {
    _statuses[i] = cleared;
    _saveStatuses();
  }

  void setStarred(int i, [bool starred = true]) {
    _stars[i] = starred;
    _saveStatuses();
  }
}
