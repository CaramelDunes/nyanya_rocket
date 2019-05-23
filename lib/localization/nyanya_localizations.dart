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

  String get challengeGetMiceType {
    return Intl.message(
      'Get Mice',
      name: 'challengeGetMiceType',
      desc: 'Get Mice type of challenge.',
    );
  }

  String get challengeRunAwayType {
    return Intl.message(
      'Run Away',
      name: 'challengeRunAwayType',
      desc: 'Run Away type of challenge.',
    );
  }

  String get challengeLunchTimeType {
    return Intl.message(
      'Lunch Time',
      name: 'challengeLunchTimeType',
      desc: 'Lunch Time type of challenge.',
    );
  }

  String get challengeOneHundredMiceType {
    return Intl.message(
      'One Hundred Mice',
      name: 'challengeOneHundredMiceType',
      desc: 'One Hundred Mice type of challenge.',
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

  String get newsLabel {
    return Intl.message(
      'News',
      name: 'newsLabel',
      desc: 'News label of the What\'s New tab.',
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

  String get sortByLabel {
    return Intl.message(
      'Sort by',
      name: 'sortByLabel',
      desc: 'Community tab of the Puzzles, Challenges screens.',
    );
  }

  String get dateLabel {
    return Intl.message(
      'Date',
      name: 'dateLabel',
      desc: 'Community tab of the Puzzles, Challenges screens.',
    );
  }

  String get popularityLabel {
    return Intl.message(
      'Popularity',
      name: 'popularityLabel',
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

  String get loginPromptText {
    return Intl.message(
      'Please sign-in first! (Settings—Account Management)',
      name: 'loginPromptText',
      desc: 'Login prompt of the Local Puzzles and Challenges tabs.',
    );
  }

  String get publishLabel {
    return Intl.message(
      'Publish',
      name: 'publishLabel',
      desc: 'Publish tooltip of the Local Puzzles and Challenges tabs.',
    );
  }

  String get publishSuccessText {
    return Intl.message(
      'Puzzle published!',
      name: 'publishSuccessText',
      desc:
          'Publish success text (snackbar) of the Local Puzzles and Challenges tabs.',
    );
  }

  String get puzzleNotCompletedLocallyText {
    return Intl.message(
      'Puzzle not published as you didn\'t complete it',
      name: 'puzzleNotCompletedLocallyText',
      desc: 'Local Puzzles and Challenges tabs.',
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

  String get nicknameLabel {
    return Intl.message(
      'Nickname',
      name: 'nicknameLabel',
      desc: 'Nickname field label of the Multiplayer screen.',
    );
  }

  String get invalidNicknameText {
    return Intl.message(
      'Please enter a valid nickname.',
      name: 'invalidNicknameText',
      desc: 'When entered nickname is incorrect in the Multiplayer screen.',
    );
  }

  String get invalidHostnameText {
    return Intl.message(
      'Please enter a valid hostname.',
      name: 'invalidHostnameText',
      desc: 'When entered hostname is incorrect in the Multiplayer screen.',
    );
  }

  String get hostnameLabel {
    return Intl.message(
      'Server hostname',
      name: 'hostnameLabel',
      desc: 'Server hostname field label of the Multiplayer screen.',
    );
  }

  String get createLabel {
    return Intl.message(
      'Create',
      name: 'createLabel',
      desc: 'Create button label of the Multiplayer screen.',
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

  String get nameLabel {
    return Intl.message(
      'Name',
      name: 'nameLabel',
      desc: 'Name field of the new tab of the Editor screen.',
    );
  }

  String get invalidNameText {
    return Intl.message(
      'Please enter a valid name.',
      name: 'invalidNameText',
      desc: 'When entered name is invalid in the new tab of the Editor screen.',
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

  String get saveLabel {
    return Intl.message(
      'Save',
      name: 'saveLabel',
      desc: 'Save button label of editor.',
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

  // Success Overlay
  String get stageClearedText {
    return Intl.message(
      'Stage cleared!',
      name: 'stageClearedText',
      desc: 'Stage cleared text of success overlay.',
    );
  }

  String get nextLevelLabel {
    return Intl.message(
      'Next level',
      name: 'nextLevelLabel',
      desc: 'Next level button label of success overlay.',
    );
  }

  // Tutorial screen
  String get generalLabel {
    return Intl.message(
      'General',
      name: 'generalLabel',
      desc: 'General label of the tutorial screen.',
    );
  }

  String get tilesTutorialLabel {
    return Intl.message(
      'Tiles',
      name: 'tilesTutorialLabel',
      desc: 'Tiles label of the tutorial screen.',
    );
  }

  String get pitTutorialText {
    return Intl.message(
      'Black Hole (technically a square though...)',
      name: 'pitTutorialText',
      desc: 'Pit text of the tutorial screen.',
    );
  }

  String get rocketTutorialText {
    return Intl.message(
      'Rocket',
      name: 'rocketTutorialText',
      desc: 'Rocket text of the tutorial screen.',
    );
  }

  String get arrowTutorialText {
    return Intl.message(
      'Arrow',
      name: 'arrowTutorialText',
      desc: 'Arrow text of the tutorial screen.',
    );
  }

  String get entitiesTutorialLabel {
    return Intl.message(
      'Entities',
      name: 'entitiesTutorialLabel',
      desc: 'Entities label of the tutorial screen.',
    );
  }

  String get mouseTutorialText {
    return Intl.message(
      'Mouse',
      name: 'mouseTutorialText',
      desc: 'Mouse text of the tutorial screen.',
    );
  }

  String get catTutorialText {
    return Intl.message(
      'Cats are slower than mice.\nWhen a cat meets an arrow head-on, it will damage it or destroy it if already damaged.',
      name: 'catTutorialText',
      desc: 'Cat text of the tutorial screen.',
    );
  }

  String get movementTutorialText {
    return Intl.message(
      """

An entity walks straight until it encounters an arrow or a wall.
For some reasons, mice and cats prefer turning right when hitting a wall...
""",
      name: 'movementTutorialText',
      desc: 'Movement text of the tutorial screen.',
    );
  }

  String get placementTutorialLabel {
    return Intl.message(
      'Arrow placement',
      name: 'placementTutorialLabel',
      desc: 'Arrow placement label of the tutorial screen.',
    );
  }

  String get arrowDnDTutorialText {
    return Intl.message(
      'Arrows can be drag n\' dropped...',
      name: 'arrowDnDTutorialText',
      desc: 'Arrow drag n drop placement text of the tutorial screen.',
    );
  }

  String get arrowSwipeTutorialText {
    return Intl.message(
      '...or swiped',
      name: 'arrowSwipeTutorialText',
      desc: 'Arrow swipe placement text of the tutorial screen.',
    );
  }

  String get arrowRemoveTutorialText {
    return Intl.message(
      'Arrows can be removed by tapping',
      name: 'arrowRemoveTutorialText',
      desc: 'Arrow remove text of the tutorial screen.',
    );
  }

  String get puzzleTutorialText {
    return Intl.message(
      """
A Puzzle game is won when every mice has reached a rocket.
You have a restricted amount of arrows to achieve that goal.

Note that you cannot place or remove an arrow after pressing the play button; you'll need to reset the level first.

You'll lose if:
  • A cat enters a rocket before every mice is safe.
  • A mouse gets eaten by a cat.
  • A mouse falls into a black hole.

You'll be awarded a star if you complete a level without using all the available arrows.
""",
      name: 'puzzleTutorialText',
      desc: 'Puzzle text of the tutorial screen.',
    );
  }

  String get challengeTutorialText {
    return Intl.message(
      """
Challenges are fast-paced games where you only have 30 seconds to complete an objective that depends on the type of the challenge.

Unlike Puzzle mode, you can place as many arrows as you want but they expire after 10 seconds and there can only be 3 arrows at a time (placing more will replace the oldest).""",
      name: 'challengeTutorialText',
      desc: 'Challenge text of the tutorial screen.',
    );
  }

  String get challengeGetMiceText {
    return Intl.message(
      'Like in Puzzle mode, you need to make all the mice, but as fast as possible this time.',
      name: 'challengeGetMiceText',
      desc: 'Get Mice challenge text of the tutorial screen.',
    );
  }

  String get challengeLunchTimeText {
    return Intl.message(
      'No rocket here, feed the cats with every single mouse!',
      name: 'challengeLunchTimeText',
      desc: 'Lunch Time challenge text of the tutorial screen.',
    );
  }

  String get challengeOneHundredMiceText {
    return Intl.message(
      'Mice and cats will naturally spawn, get one hundred of mice!',
      name: 'challengeOneHundredMiceText',
      desc: 'One Hundred Mice challenge text of the tutorial screen.',
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

  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: 'Cancel string.',
    );
  }

  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: 'Accept string.',
    );
  }

  String get deny {
    return Intl.message(
      'Deny',
      name: 'deny',
      desc: 'Deny string.',
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

  String get privacyPolicyLabel {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicyLabel',
      desc: 'Displayed in the drawer.',
    );
  }

  String get playLabel {
    return Intl.message(
      'Play',
      name: 'playLabel',
      desc: 'Displayed in various buttons.',
    );
  }

  String get playersLabel {
    return Intl.message(
      'players',
      name: 'playersLabel',
      desc: 'Displayed in various locations.',
    );
  }

  String get boardSelectionText {
    return Intl.message(
      'Tap to select',
      name: 'boardSelectionText',
      desc: 'Displayed in board picker.',
    );
  }

  String get easyLabel {
    return Intl.message(
      'Easy',
      name: 'easyLabel',
      desc: 'Displayed in original puzzles tab.',
    );
  }

  String get intermediateLabel {
    return Intl.message(
      'Intermediate',
      name: 'intermediateLabel',
      desc: 'Displayed in original puzzles tab.',
    );
  }

  String get hardLabel {
    return Intl.message(
      'Hard',
      name: 'hardLabel',
      desc: 'Displayed in original puzzles tab.',
    );
  }

  String get veryHardLabel {
    return Intl.message(
      'Very Hard',
      name: 'veryHardLabel',
      desc: 'Displayed in original puzzles tab.',
    );
  }

  String get completedLabel {
    return Intl.message(
      '% Completed',
      name: 'completedLabel',
      desc: 'Displayed in original puzzles tab.',
    );
  }

  String get showCompletedLabel {
    return Intl.message(
      'Show Completed',
      name: 'showCompletedLabel',
      desc: 'Displayed in original puzzles tab.',
    );
  }

  // Account Management
  String get accountManagementLabel {
    return Intl.message(
      'Account Management',
      name: 'accountManagementLabel',
      desc: 'Displayed in the settings screen.',
    );
  }

  String get loginStatusLabel {
    return Intl.message(
      'Login status',
      name: 'loginStatusLabel',
      desc: 'Displayed in the settings and account management screens.',
    );
  }

  String get connectedStatusLabel {
    return Intl.message(
      'Connected',
      name: 'connectedStatusLabel',
      desc: 'Displayed in the account management screens.',
    );
  }

  String get disconnectedStatusLabel {
    return Intl.message(
      'Disconnected',
      name: 'disconnectedStatusLabel',
      desc: 'Displayed in the account management screen.',
    );
  }

  String get signInLabel {
    return Intl.message(
      'Tap to sign-in',
      name: 'signInLabel',
      desc: 'Displayed in the account management screen.',
    );
  }

  String get signInDialogTitle {
    return Intl.message(
      'Privacy Policy',
      name: 'signInDialogTitle',
      desc: 'Displayed in the account management screen.',
    );
  }

  String get signOutLabel {
    return Intl.message(
      'Tap to sign-out',
      name: 'signOutLabel',
      desc: 'Displayed in the account management screen.',
    );
  }

  String get signOutDialogTitle {
    return Intl.message(
      'Confirm sign-out',
      name: 'signOutDialogTitle',
      desc: 'Displayed in the account management screen.',
    );
  }

  String get signOutDialogText {
    return Intl.message(
      'Are you sure you want to sign-out?\n\nYou will lose the ability to publish community challenges and puzzles.',
      name: 'signOutDialogText',
      desc: 'Displayed in the account management screen.',
    );
  }

  String get displayNameDialogTitle {
    return Intl.message(
      'Please enter your new display name',
      name: 'displayNameDialogTitle',
      desc: 'Displayed in the account management screen.',
    );
  }

  String get unauthenticatedError {
    return Intl.message(
      'Error: Unauthenticated',
      name: 'unauthenticatedError',
      desc: 'Displayed in the account management screen.',
    );
  }

  String get invalidDisplayNameError {
    return Intl.message(
      'Error: The provided display name is invalid!',
      name: 'invalidDisplayNameError',
      desc: 'Displayed in the account management screen.',
    );
  }

  String get displayNameLabel {
    return Intl.message(
      'Display name',
      name: 'displayNameLabel',
      desc: 'Displayed in the account management screen.',
    );
  }

  String get tapToChangeDisplayNameLabel {
    return Intl.message(
      'Tap to change',
      name: 'tapToChangeDisplayNameLabel',
      desc: 'Displayed in the account management screen.',
    );
  }

  String get displayNameChangeSuccessText {
    return Intl.message(
      'Display name successfully changed!',
      name: 'displayNameChangeSuccessText',
      desc: 'Displayed in the account management screen.',
    );
  }

  String get confirmLabel {
    return Intl.message(
      'Confirm',
      name: 'confirmLabel',
      desc: 'Displayed in the account management screen.',
    );
  }

  String get displayNameFormatText {
    return Intl.message(
      'Between 2 and 24 characters (no space).',
      name: 'displayNameFormatText',
      desc: 'Displayed in the account management screen.',
    );
  }
}
