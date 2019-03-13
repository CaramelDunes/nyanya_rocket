import 'package:nyanya_rocket/models/options.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef Widget OptionWidgetBuilder(BuildContext context, Options options);

class OptionsHolder extends StatefulWidget {
  final OptionWidgetBuilder optionWidgetBuilder;

  const OptionsHolder({Key key, this.optionWidgetBuilder}) : super(key: key);

  @override
  OptionsHolderState createState() => OptionsHolderState();

  static OptionsHolderState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<OptionsHolderState>());
  }
}

class OptionsHolderState extends State<OptionsHolder> {
  SharedPreferences _prefs;
  Options _options;

  get options => _options;

  set options(Options value) {
    value.toSharedPrefs(_prefs);

    setState(() {
      _options = value;
    });
  }

  @override
  void initState() {
    super.initState();

    _future().then((SharedPreferences prefs) {
      _options = Options.fromSharedPrefs(prefs);

      setState(() {
        _prefs = prefs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_prefs == null) return Container(color: Colors.transparent);

    return widget.optionWidgetBuilder(context, _options);
  }

  Future<SharedPreferences> _future() async {
    return await SharedPreferences.getInstance();
  }
}
