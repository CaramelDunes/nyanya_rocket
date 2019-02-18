import 'package:flutter/material.dart';
import 'package:nyanya_rocket/options_holder.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() {
    return new SettingsState();
  }
}

class SettingsState extends State<Settings> {
  bool sound = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        drawer: DefaultDrawer(),
        body: ListView(
          children: <Widget>[
            SwitchListTile(
              title: Text("Sounds"),
              onChanged: (bool value) {
                setState(() {
                  OptionsHolder.of(context).options = OptionsHolder.of(context)
                      .options
                      .copyWith(playSounds: value);
                });
              },
              value: OptionsHolder.of(context).options.playSounds,
            ),
            SwitchListTile(
              title: Text("Dark theme"),
              onChanged: (bool value) {
                setState(() {
                  OptionsHolder.of(context).options = OptionsHolder.of(context)
                      .options
                      .copyWith(darkTheme: value);
                });
              },
              value: Theme.of(context).brightness == Brightness.dark,
            )
          ],
        ));
  }
}
