
import 'package:shared_preferences/shared_preferences.dart';

import 'boolean_parameter.dart';

class FirstRun extends BooleanParameter {
  FirstRun({required SharedPreferences sharedPreferences})
      : super(
            sharedPreferences: sharedPreferences,
            key: 'options.firstRun',
            defaultValue: false);
}
