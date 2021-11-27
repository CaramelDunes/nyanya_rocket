import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/screens/privacy_policy_prompt/privacy_policy_prompt.dart';
import 'package:nyanya_rocket/screens/settings/settings.dart';
import 'package:nyanya_rocket/screens/tutorial/tutorial.dart';

import '../../config.dart';

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
            leading: const Icon(Icons.home),
            title: Text(NyaNyaLocalizations.of(context).homeTitle),
            onTap: () {
              Navigator.pop(context);
              Router.of(context)
                  .routerDelegate
                  .setNewRoutePath(const NyaNyaRoutePath.home());
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.puzzlePiece),
            title: Text(NyaNyaLocalizations.of(context).puzzlesTitle),
            onTap: () {
              Navigator.pop(context);
              Router.of(context)
                  .routerDelegate
                  .setNewRoutePath(const NyaNyaRoutePath.puzzles());
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.stopwatch),
            title: Text(NyaNyaLocalizations.of(context).challengesTitle),
            onTap: () {
              Navigator.pop(context);
              Router.of(context)
                  .routerDelegate
                  .setNewRoutePath(const NyaNyaRoutePath.challenges());
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.gamepad),
            title: Text(NyaNyaLocalizations.of(context).multiplayerTitle),
            onTap: () {
              Navigator.pop(context);
              Router.of(context)
                  .routerDelegate
                  .setNewRoutePath(const NyaNyaRoutePath.multiplayer());
            },
          ),
          ListTile(
            leading: const Icon(Icons.mode_edit),
            title: Text(NyaNyaLocalizations.of(context).editorTitle),
            onTap: () {
              Navigator.pop(context);
              Router.of(context)
                  .routerDelegate
                  .setNewRoutePath(const NyaNyaRoutePath.editor());
            },
          ),
          const Divider(),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.book),
            title: Text(NyaNyaLocalizations.of(context).tutorialTitle),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Tutorial()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(NyaNyaLocalizations.of(context).settingsTitle),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Settings()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
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
            icon: const FaIcon(FontAwesomeIcons.questionCircle),
            applicationLegalese: kAboutText,
            applicationVersion: kAboutVersion,
          )
        ],
      ),
    );
  }
}
