import 'dart:collection';

import 'package:nyanya_rocket/screens/challenges/tabs/original_challenges.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengeProgressionManager {
  static final Future<SharedPreferences> prefs =
      SharedPreferences.getInstance();

  static String _timeKeyOf(int i) => "challenge.original.$i.time";

  static Future<SplayTreeSet<int>> getCleared() async {
    SharedPreferences prefs = await ChallengeProgressionManager.prefs;
    SplayTreeSet<int> cleared = SplayTreeSet();

    for (int i = 0; i < OriginalChallenges.challenges.length; i += 1) {
      int? time = prefs.getInt(_timeKeyOf(i));
      if (time != null && time > 0) {
        cleared.add(i);
      }
    }
    return cleared;
  }

  static Future<List<Duration>> getTimes() async {
    SharedPreferences prefs = await ChallengeProgressionManager.prefs;
    List<Duration> times =
        List.filled(OriginalChallenges.challenges.length, Duration());

    for (int i = 0; i < OriginalChallenges.challenges.length; i += 1) {
      times[i] = Duration(milliseconds: prefs.getInt(_timeKeyOf(i)) ?? 0);
    }

    return times;
  }

  static Future<void> setTime(int i, Duration time) async {
    SharedPreferences prefs = await ChallengeProgressionManager.prefs;
    return prefs.setInt(_timeKeyOf(i), time.inMilliseconds).then((bool _) {});
  }
}
