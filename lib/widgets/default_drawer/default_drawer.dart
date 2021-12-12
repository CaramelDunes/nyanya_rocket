import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config.dart';
import '../../localization/nyanya_localizations.dart';
import '../../routing/nyanya_route_path.dart';
import '../../screens/privacy_policy_prompt/privacy_policy_prompt.dart';
import '../../screens/settings/settings.dart';
import '../../screens/tutorial/tutorial.dart';

class DefaultDrawer extends StatelessWidget {
  const DefaultDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localized = NyaNyaLocalizations.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child:
                  Image.asset('assets/graphics/adaptive_icon_foreground.png')),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(localized.homeTitle),
            onTap: () {
              Navigator.pop(context);
              Router.of(context)
                  .routerDelegate
                  .setNewRoutePath(const NyaNyaRoutePath.home());
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.puzzlePiece),
            title: Text(localized.puzzlesTitle),
            onTap: () {
              Navigator.pop(context);
              Router.of(context)
                  .routerDelegate
                  .setNewRoutePath(const NyaNyaRoutePath.originalPuzzles());
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.stopwatch),
            title: Text(localized.challengesTitle),
            onTap: () {
              Navigator.pop(context);
              Router.of(context)
                  .routerDelegate
                  .setNewRoutePath(const NyaNyaRoutePath.originalChallenges());
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.gamepad),
            title: Text(localized.multiplayerTitle),
            onTap: () {
              Navigator.pop(context);
              Router.of(context)
                  .routerDelegate
                  .setNewRoutePath(const NyaNyaRoutePath.multiplayer());
            },
          ),
          ListTile(
            leading: const Icon(Icons.mode_edit),
            title: Text(localized.editorTitle),
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
            title: Text(localized.tutorialTitle),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Tutorial()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(localized.settingsTitle),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Settings()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: Text(localized.privacyPolicyLabel),
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
