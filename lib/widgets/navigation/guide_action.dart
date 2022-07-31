import 'package:flutter/material.dart';

import '../../localization/nyanya_localizations.dart';
import '../../screens/tutorial/tutorial.dart';

class GuideAction extends StatelessWidget {
  const GuideAction({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: NyaNyaLocalizations.of(context).tutorialTitle,
      icon: const Icon(Icons.help_outline),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const Tutorial()));
      },
    );
  }
}
