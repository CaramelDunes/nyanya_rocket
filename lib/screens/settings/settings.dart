import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/options_holder.dart';
import 'package:nyanya_rocket/screens/settings/account_management.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(NyaNyaLocalizations.of(context).settingsTitle),
        ),
        body: ListView(
          children: <Widget>[
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
                      child: Text('Auto'),
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
            ),
            ListTile(
              title: Text('Account Management'),
              subtitle: Text(
                  'Status: ${AccountManagement.user.isConnected ? 'Connected': 'Not Connected'}'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return AccountManagement();
                }));
              },
            ),
          ],
        ));
  }
}
