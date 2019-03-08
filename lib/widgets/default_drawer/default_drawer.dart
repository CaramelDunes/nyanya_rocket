import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DefaultDrawer extends StatelessWidget {
  const DefaultDrawer({Key key}) : super(key: key);

  static final RoutePredicate predicate = (Route<dynamic> route) {
    return route is ModalRoute && route.settings.name == '/';
  };

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
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/', predicate);
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.puzzlePiece),
            title: Text('Puzzles'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/puzzles', predicate);
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.stopwatch),
            title: Text('Challenges'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/challenges', predicate);
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.gamepad),
            title: Text('Multiplayer'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/multiplayer', predicate);
            },
          ),
          ListTile(
            leading: Icon(Icons.mode_edit),
            title: Text('Editor'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/editor', predicate);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(FontAwesomeIcons.book),
            title: Text('How to play'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/tutorial', predicate);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          AboutListTile(
            icon: Icon(FontAwesomeIcons.questionCircle),
            applicationVersion: '1.0',
            //applicationLegalese: 'Copyright © CaramelDunes',
          ),
        ],
      ),
    );
  }
}
