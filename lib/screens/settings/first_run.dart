import 'boolean_parameter.dart';

class FirstRun extends BooleanParameter {
  FirstRun({required super.sharedPreferences})
      : super(key: 'options.firstRun', defaultValue: false);
}
