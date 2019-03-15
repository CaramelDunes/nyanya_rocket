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

  String get firstTimeWelcome {
    return Intl.message(
      'Welcome,',
      name: 'firstTimeWelcome',
      desc: 'First time welcome label of the Home screen.',
    );
  }

  String get firstTimeText {
    return Intl.message(
      'First time here? Check the tutorial!',
      name: 'firstTimeText',
      desc: 'First time welcome text of the Home screen.',
    );
  }

  String get firstTimeButtonLabel {
    return Intl.message(
      'Take me to it!',
      name: 'firstTimeButtonLabel',
      desc: 'First time, go to tutorial button of the Home screen.',
    );
  }

  String get contributingTab {
    return Intl.message(
      'Contributing',
      name: 'contributingTab',
      desc: 'Contributing tab of the Home screen.',
    );
  }

  String get contributingText {
    return Intl.message(
      '''Help NyaNya Rocket!

You don\'t need any particular skills to contribute, you can:
  • Report bugs and ask for new features
  • Translate
  • Improve graphical assets and animation
  • Code

For more information, head over to ''',
      name: 'contributingText',
      desc: 'Text of the Contributing tab of Home screen.',
    );
  }

  String get contributorsLabel {
    return Intl.message(
      'Contributors',
      name: 'contributorsLabel',
      desc: 'Contributors label in Contributing tab of the Home screen.',
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

  // Challenge screen
  String get getMiceObjectiveText {
    return Intl.message(
      'Lead all mice to the goal within 30 sec.',
      name: 'getMiceObjectiveText',
      desc: 'Short explanation of the Get Mice challenge type.',
    );
  }

  String get runAwayObjectiveText {
    return Intl.message(
      'Avoid the cat and get to the goal!',
      name: 'runAwayObjectiveText',
      desc: 'Short explanation of the Run Away challenge type.',
    );
  }

  String get lunchTimeObjectiveText {
    return Intl.message(
      'Feed the cat!',
      name: 'lunchTimeObjectiveText',
      desc: 'Short explanation of the Lunch Time challenge type.',
    );
  }

  String get oneHundredMiceObjectiveText {
    return Intl.message(
      'Collect 100 mice in 30 sec.',
      name: 'oneHundredMiceObjectiveText',
      desc: 'Short explanation of the One Hundred Mice challenge type.',
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

  String get discardDialogTitle {
    return Intl.message(
      'Confirm leave',
      name: 'discardDialogTitle',
      desc: 'Discard confirmation dialog of editor.',
    );
  }

  String get discardDialogMessage {
    return Intl.message(
      'Are you sure you want to leave?\nAny unsaved changes will be discarded!',
      name: 'discardDialogMessage',
      desc: 'Discard confirmation dialog of editor.',
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

  // Misc
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: 'Yes string.',
    );
  }

  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: 'No string.',
    );
  }

  String get loadingLabel {
    return Intl.message(
      'Loading...',
      name: 'loadingLabel',
      desc: 'Loading... label of async loaded data.',
    );
  }

  String get notImplementedText {
    return Intl.message(
      'Not (yet) available!\nWant it to be a priority? :-)',
      name: 'notImplementedText',
      desc: 'Text of the NotImplementedWidget.',
    );
  }

  String get emptyListText {
    return Intl.message(
      'Nothing here...',
      name: 'emptyListText',
      desc: 'Displayed when a list is empty.',
    );
  }
}
