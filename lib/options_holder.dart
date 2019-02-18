import 'package:nyanya_rocket/models/options.dart';
import 'package:flutter/material.dart';

typedef Widget OptionWidgetBuilder(BuildContext context, Options theme);

class OptionsHolder extends StatefulWidget {
  final OptionWidgetBuilder optionWidgetBuilder;

  const OptionsHolder({Key key, this.optionWidgetBuilder}) : super(key: key);

  @override
  OptionsHolderState createState() => new OptionsHolderState();

  static OptionsHolderState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<OptionsHolderState>());
  }
}

class OptionsHolderState extends State<OptionsHolder> {
  Options _options;

  get options => _options;

  set options(Options value) {
    setState(() {
      _options = value;
    });
  }

  @override
  void initState() {
    super.initState();

    _options = Options(darkTheme: false, playSounds: false);
  }

  @override
  Widget build(BuildContext context) {
    return widget.optionWidgetBuilder(context, _options);
  }
}
