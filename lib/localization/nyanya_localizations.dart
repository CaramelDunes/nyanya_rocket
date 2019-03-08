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
}
