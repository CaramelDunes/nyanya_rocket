import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/user.dart';
import 'package:nyanya_rocket/screens/settings/account_management.dart';
import 'package:nyanya_rocket/screens/settings/dark_mode.dart';
import 'package:nyanya_rocket/screens/settings/language.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
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
                Provider.of<DarkMode>(context, listen: false).enabled = value;
              },
              value: Provider.of<DarkMode>(context).enabled,
            ),
            ListTile(
              title: Text(NyaNyaLocalizations.of(context).languageLabel),
              trailing: DropdownButton<String>(
                  value: Provider.of<Language>(context).value,
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
                    DropdownMenuItem(
                      child: Text('Deutsch'),
                      value: 'de',
                    ),
                  ],
                  onChanged: (String language) {
                    Provider.of<Language>(context, listen: false).value =
                        language;
                  }),
            ),
            Consumer<User>(
              builder: (context, user, _) => ListTile(
                title: Text(
                    NyaNyaLocalizations.of(context).accountManagementLabel),
                subtitle: Text(
                    '${NyaNyaLocalizations.of(context).loginStatusLabel}: ${user.isConnected ? NyaNyaLocalizations.of(context).connectedStatusLabel : NyaNyaLocalizations.of(context).disconnectedStatusLabel}'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return AccountManagement();
                  }));
                },
              ),
            ),
          ],
        ));
  }
}
