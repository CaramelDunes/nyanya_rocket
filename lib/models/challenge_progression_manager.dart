import 'package:nyanya_rocket/screens/challenges/widgets/official_challenges.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengeProgressionManager {
  List<bool> _statuses =
      List.filled(OfficialChallenges.challenges.length, false);
  List<Duration> _times =
      List.filled(OfficialChallenges.challenges.length, Duration());
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static String clearedKeyOf(int i) => "challenge.official.$i.cleared";
  static String timeKeyOf(int i) => "challenge.official.$i.time";

  Future<void> loadStatuses() async {
    SharedPreferences prefs = await this.prefs;

    for (int i = 0; i < _statuses.length; i += 1) {
      _statuses[i] = prefs.getBool(clearedKeyOf(i)) ?? false;

      if (_statuses[i]) {
        _times[i] = Duration(milliseconds: prefs.getInt(timeKeyOf(i)) ?? 0);
      }
    }

    return;
  }

  Future<void> _saveStatuses() async {
    SharedPreferences prefs = await this.prefs;

    for (int i = 0; i < _statuses.length; i += 1) {
      prefs.setBool(clearedKeyOf(i), _statuses[i]);

      if (_statuses[i]) {
        prefs.setInt(timeKeyOf(i), _times[i].inMilliseconds);
      }
    }
  }

  bool hasCleared(int i) => _statuses[i];
  Duration timeOf(int i) => _times[i];

  void setCleared(int i, [Duration duration = Duration.zero]) {
    if (!_statuses[i] || _times[i] > duration) {
      _times[i] = duration;
    }

    _statuses[i] = duration.inSeconds != 0;
    _saveStatuses();
  }
}
