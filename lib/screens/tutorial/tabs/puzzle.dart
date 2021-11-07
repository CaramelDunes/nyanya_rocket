import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';

class Puzzle extends StatelessWidget {
  const Puzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        Text(NyaNyaLocalizations.of(context).puzzleTutorialText),
        Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Text(
                NyaNyaLocalizations.of(context).arrowRemoveTutorialText,
                textAlign: TextAlign.center,
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/animations/remove_arrow.gif'),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
