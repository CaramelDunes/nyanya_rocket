import 'package:firebase_auth/firebase_auth.dart';
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
  FirebaseUser _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _auth.currentUser().then((FirebaseUser user) => setState(() {
          _user = user;
        }));
  }

  Future<String> _showDialog(BuildContext context, String initialValue) {
    String displayName;

    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                    ),
                    onChanged: (String value) => displayName = value,
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              FlatButton(
                  child: const Text('OPEN'),
                  onPressed: () {
                    Navigator.pop(context, displayName);
                  })
            ],
          );
        });
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
              title: Text(
                  'Login Status: ${_user == null ? 'Not Connected' : 'Connected'}'),
              subtitle: Text(_user != null ? _user.uid : ''),
            ),
            Visibility(
              visible: _user != null,
              child: ListTile(
                title: Text(
                    'Display Name: ${_user != null ? _user.displayName ?? "(Empty)" : ''}'),
                onTap: () {
                  _showDialog(context, _user.displayName)
                      .then((String displayName) {
                    print(displayName);
                    _user
                        .updateProfile(
                            UserUpdateInfo()..displayName = displayName)
                        .then((void _) {
                      _user.reload().then((void _) {
                        setState(() {});
                      });
                    });
                  });
                },
              ),
            )
          ],
        ));
  }
}
