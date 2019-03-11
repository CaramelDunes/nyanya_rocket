import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/options_holder.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(NyaNyaLocalizations.of(context).settingsTitle),
        ),
        body: ListView(
          children: <Widget>[
            SwitchListTile(
              title:
                  Text(NyaNyaLocalizations.of(context).enableAnimationsLabel),
              onChanged: (bool value) {
                setState(() {
                  OptionsHolder.of(context).options = OptionsHolder.of(context)
                      .options
                      .copyWith(animations: value);
                });
              },
              value: OptionsHolder.of(context).options.animations,
            ),
            SwitchListTile(
              title: Text(NyaNyaLocalizations.of(context).darkModeLabel),
              onChanged: (bool value) {
                setState(() {
                  OptionsHolder.of(context).options = OptionsHolder.of(context)
                      .options
                      .copyWith(darkTheme: value);
                });
              },
              value: Theme.of(context).brightness == Brightness.dark,
            ),
            ListTile(
              title: Text(NyaNyaLocalizations.of(context).languageLabel),
              trailing: DropdownButton<String>(
                  value: OptionsHolder.of(context).options.language,
                  items: <DropdownMenuItem<String>>[
                    DropdownMenuItem(
                      child: Text('System'),
                      value: 'auto',
                    ),
                    DropdownMenuItem(
                      child: Text('English'),
                      value: 'en',
                    ),
                    DropdownMenuItem(
                      child: Text('Français'),
                      value: 'fr',
                    ),
                  ],
                  onChanged: (String language) {
                    OptionsHolder.of(context).options =
                        OptionsHolder.of(context)
                            .options
                            .copyWith(language: language);
                  }),
            )
          ],
        ));
  }
}
