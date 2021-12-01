import 'package:flutter/material.dart';

import '../../../config.dart';
import '../../../localization/nyanya_localizations.dart';

class Puzzle extends StatelessWidget {
  const Puzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kMaxWidthForBigScreens),
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            Text(NyaNyaLocalizations.of(context).puzzleTutorialText),
            Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
        ),
      ),
    );
  }
}
