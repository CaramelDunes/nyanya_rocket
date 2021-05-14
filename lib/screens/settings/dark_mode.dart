import 'package:shared_preferences/shared_preferences.dart';

import 'boolean_parameter.dart';

class DarkMode extends BooleanParameter {
  DarkMode({required SharedPreferences sharedPreferences})
      : super(
            sharedPreferences: sharedPreferences,
            key: 'options.darkTheme',
            defaultValue: false);
}
