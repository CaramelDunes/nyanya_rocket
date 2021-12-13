import 'package:flutter/material.dart';

import '../../localization/nyanya_localizations.dart';
import '../../screens/settings/settings.dart';

class SettingsAction extends StatelessWidget {
  const SettingsAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: NyaNyaLocalizations.of(context).settingsTitle,
      icon: const Icon(Icons.settings),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const Settings()));
      },
    );
  }
}
