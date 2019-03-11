import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';

class DefaultDrawer extends StatelessWidget {
  const DefaultDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Container()),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(NyaNyaLocalizations.of(context).homeTitle),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.puzzlePiece),
            title: Text(NyaNyaLocalizations.of(context).puzzlesTitle),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
              Navigator.pushNamed(context, '/puzzles');
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.stopwatch),
            title: Text(NyaNyaLocalizations.of(context).challengesTitle),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
              Navigator.pushNamed(context, '/challenges');
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.gamepad),
            title: Text(NyaNyaLocalizations.of(context).multiplayerTitle),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
              Navigator.pushNamed(context, '/multiplayer');
            },
          ),
          ListTile(
            leading: Icon(Icons.mode_edit),
            title: Text(NyaNyaLocalizations.of(context).editorTitle),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
              Navigator.pushNamed(context, '/editor');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(FontAwesomeIcons.book),
            title: Text(NyaNyaLocalizations.of(context).tutorialTitle),
            onTap: () {
              Navigator.pushNamed(context, '/tutorial');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(NyaNyaLocalizations.of(context).settingsTitle),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          AboutListTile(
            icon: Icon(FontAwesomeIcons.questionCircle),
            applicationVersion: '1.0',
          ),
        ],
      ),
    );
  }
}
