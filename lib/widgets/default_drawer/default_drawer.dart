import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/screens/privacy_policy_prompt/privacy_policy_prompt.dart';
import 'package:nyanya_rocket/screens/settings/settings.dart';
import 'package:nyanya_rocket/screens/tutorial/tutorial.dart';

class DefaultDrawer extends StatelessWidget {
  const DefaultDrawer({Key? key}) : super(key: key);

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
              child:
                  Image.asset('assets/graphics/adaptive_icon_foreground.png')),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(NyaNyaLocalizations.of(context).homeTitle),
            onTap: () {
              Navigator.pop(context);
              Router.of(context)
                  .routerDelegate
                  .setNewRoutePath(NyaNyaRoutePath.home());
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.puzzlePiece),
            title: Text(NyaNyaLocalizations.of(context).puzzlesTitle),
            onTap: () {
              Navigator.pop(context);
              Router.of(context)
                  .routerDelegate
                  .setNewRoutePath(NyaNyaRoutePath.puzzles());
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.stopwatch),
            title: Text(NyaNyaLocalizations.of(context).challengesTitle),
            onTap: () {
              Navigator.pop(context);
              Router.of(context)
                  .routerDelegate
                  .setNewRoutePath(NyaNyaRoutePath.challenges());
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.gamepad),
            title: Text(NyaNyaLocalizations.of(context).multiplayerTitle),
            onTap: () {
              Navigator.pop(context);
              Router.of(context)
                  .routerDelegate
                  .setNewRoutePath(NyaNyaRoutePath.multiplayer());
            },
          ),
          ListTile(
            leading: Icon(Icons.mode_edit),
            title: Text(NyaNyaLocalizations.of(context).editorTitle),
            onTap: () {
              Navigator.pop(context);
              Router.of(context)
                  .routerDelegate
                  .setNewRoutePath(NyaNyaRoutePath.editor());
            },
          ),
          Divider(),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.book),
            title: Text(NyaNyaLocalizations.of(context).tutorialTitle),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Tutorial()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(NyaNyaLocalizations.of(context).settingsTitle),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Settings()));
            },
          ),
          ListTile(
            leading: Icon(Icons.library_books),
            title: Text(NyaNyaLocalizations.of(context).privacyPolicyLabel),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const PrivacyPolicyPrompt(askUser: false)));
            },
          ),
          AboutListTile(
            icon: FaIcon(FontAwesomeIcons.questionCircle),
            applicationLegalese:
                'Made with ❤ by CaramelDunes️\n\n\nPowered by Flutter',
            applicationVersion: '1.0',
          )
        ],
      ),
    );
  }
}
