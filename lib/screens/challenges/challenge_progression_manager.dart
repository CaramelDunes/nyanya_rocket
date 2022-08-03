import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'tabs/original_challenges.dart';

class ChallengeProgressionManager with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  final Map<int, Duration> _times = {};

  ChallengeProgressionManager(this.sharedPreferences) {
    _readTimes();
  }

  Map<int, Duration> getTimes() => _times;

  Future<bool> setTime(int i, Duration time) {
    _times[i] = time;
    notifyListeners();
    return sharedPreferences.setInt(_timeKeyOf(i), time.inMilliseconds);
  }

  static String _timeKeyOf(int i) => "challenge.original.$i.time";

  void _readTimes() {
    for (int i = 0; i < OriginalChallenges.challenges.length; i += 1) {
      int? timeMilliseconds = sharedPreferences.getInt(_timeKeyOf(i));

      if (timeMilliseconds != null && timeMilliseconds > 0) {
        _times[i] = Duration(milliseconds: timeMilliseconds);
      }
    }
  }

  bool isChallengeCleared(int i) {
    return _times.containsKey(i);
  }

  int getFirstNotClearedChallenge() {
    int i = 0;

    while (isChallengeCleared(i)) {
      i++;
    }

    return i;
  }
}
