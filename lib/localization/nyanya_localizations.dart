import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nyanya_rocket/localization/messages_all.dart';

class NyaNyaLocalizations {
  static Future<NyaNyaLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return NyaNyaLocalizations();
    });
  }

  static NyaNyaLocalizations of(BuildContext context) {
    return Localizations.of<NyaNyaLocalizations>(context, NyaNyaLocalizations);
  }

  String get puzzleType {
    return Intl.message(
      'Puzzle',
      name: 'puzzleType',
      desc: 'Puzzle type of game.',
    );
  }

  String get challengeType {
    return Intl.message(
      'Challenge',
      name: 'challengeType',
      desc: 'Challenge type of game.',
    );
  }

  String get multiplayerType {
    return Intl.message(
      'Multiplayer',
      name: 'multiplayerType',
      desc: 'Multiplayer type of game.',
    );
  }

  String get challengesTitle {
    return Intl.message(
      'Challenges',
      name: 'challengesTitle',
      desc: 'Challenges title in AppBar, Drawer...',
    );
  }

  String get puzzlesTitle {
    return Intl.message(
      'Puzzles',
      name: 'puzzlesTitle',
      desc: 'Puzzles title in AppBar, Drawer...',
    );
  }

  String get multiplayerTitle {
    return Intl.message(
      'Multiplayer',
      name: 'multiplayerTitle',
      desc: 'Multiplayer title in AppBar, Drawer...',
    );
  }

  String get editorTitle {
    return Intl.message(
      'Editor',
      name: 'editorTitle',
      desc: 'Editor title in AppBar, Drawer...',
    );
  }

  String get settingsTitle {
    return Intl.message(
      'Settings',
      name: 'settingsTitle',
      desc: 'Settings title in AppBar, Drawer...',
    );
  }

  String get homeTitle {
    return Intl.message(
      'Home',
      name: 'homeTitle',
      desc: 'Home title in AppBar, Drawer...',
    );
  }

  String get tutorialTitle {
    return Intl.message(
      'How to play',
      name: 'tutorialTitle',
      desc: 'Tutorial title in AppBar, Drawer...',
    );
  }

  // Home screen
  String get whatsNewTab {
    return Intl.message(
      'What\'s New?',
      name: 'whatsNewTab',
      desc: 'What\'s New tab of the Home screen.',
    );
  }

  String get contributingTab {
    return Intl.message(
      'Contributing',
      name: 'contributingTab',
      desc: 'Contributing tab of the Home screen.',
    );
  }

  // Puzzles, Challenges screens
  String get originalTab {
    return Intl.message(
      'Original',
      name: 'originalTab',
      desc: 'Original tab of the Puzzles, Challenges screens.',
    );
  }

  String get communityTab {
    return Intl.message(
      'Community',
      name: 'communityTab',
      desc: 'Community tab of the Puzzles, Challenges screens.',
    );
  }

  String get deviceTab {
    return Intl.message(
      'Device',
      name: 'deviceTab',
      desc: 'Device tab of the Puzzles, Challenges screens.',
    );
  }

  // Multiplayer screen
  String get lanTab {
    return Intl.message(
      'LAN',
      name: 'lanTab',
      desc: 'LAN tab of the Multiplayer screen.',
    );
  }

  String get matchmakingTab {
    return Intl.message(
      'Matchmaking',
      name: 'matchmakingTab',
      desc: 'Matchmaking tab of the Multiplayer screen.',
    );
  }

  // Editor screen
  String get newTab {
    return Intl.message(
      'New',
      name: 'newTab',
      desc: 'New tab of the Editor screen.',
    );
  }

  String get editTab {
    return Intl.message(
      'Edit',
      name: 'editTab',
      desc: 'Edit tab of the Editor screen.',
    );
  }

  // Settings screen
  String get enableAnimationsLabel {
    return Intl.message(
      'Enable Animations',
      name: 'enableAnimationsLabel',
      desc: 'Enable Animations setting of the Settings screen.',
    );
  }

  String get darkModeLabel {
    return Intl.message(
      'Dark Mode',
      name: 'darkModeLabel',
      desc: 'Dark Mode setting of the Settings screen.',
    );
  }

  String get languageLabel {
    return Intl.message(
      'Language',
      name: 'languageLabel',
      desc: 'Language setting of the Settings screen.',
    );
  }
}
