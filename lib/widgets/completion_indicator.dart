import 'package:flutter/material.dart';
import '../localization/nyanya_localizations.dart';

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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            NyaNyaLocalizations.of(context)
                .completedPercentLabel((completedRatio * 100).floor()),
            textAlign: TextAlign.center,
          ),
          Row(
            children: <Widget>[
              Text(
                  NyaNyaLocalizations.of(context)
                      .showCompletedLabel
                      .toUpperCase(),
                  style: Theme.of(context).textTheme.button),
              Checkbox(
                value: showCompleted,
                onChanged: onChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
