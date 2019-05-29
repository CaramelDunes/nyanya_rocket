import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';

class CompletionIndicator extends StatelessWidget {
  final double completedRatio;
  final bool showCompleted;
  final ValueChanged<bool> onChanged;

  const CompletionIndicator(
      {Key key,
      @required this.completedRatio,
      @required this.showCompleted,
      @required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.3),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                  child: Center(
                      child: Text('${(completedRatio * 100).floor()}' +
                          NyaNyaLocalizations.of(context).completedLabel)))),
          Expanded(
            flex: 2,
            child: CheckboxListTile(
              value: showCompleted,
              onChanged: onChanged,
              title: Text(NyaNyaLocalizations.of(context)
                  .showCompletedLabel
                  .toUpperCase()),
            ),
          ),
        ],
      ),
    );
  }
}
