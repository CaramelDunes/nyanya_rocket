// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(percentCompleted) => "${percentCompleted}% completed";

  static m1(minuteCount) => "${minuteCount} minutes";

  static m2(playerCount) => "${playerCount} players";

  static m3(queueLength) => "${queueLength} players in queue.";

  static m4(position, queueLength) => "Position in queue: ${position} / ${queueLength}";

  static m5(localIp) => "This device\'s IP: ${localIp}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "accept" : MessageLookupByLibrary.simpleMessage("Accept"),
    "accountManagementLabel" : MessageLookupByLibrary.simpleMessage("Account Management"),
    "arrowDnDTutorialText" : MessageLookupByLibrary.simpleMessage("Arrows can be drag n\' dropped..."),
    "arrowRemoveTutorialText" : MessageLookupByLibrary.simpleMessage("Arrows can be removed by tapping"),
    "arrowSwipeTutorialText" : MessageLookupByLibrary.simpleMessage("...or swiped"),
    "arrowTutorialText" : MessageLookupByLibrary.simpleMessage("Arrow"),
    "back" : MessageLookupByLibrary.simpleMessage("Back"),
    "boardSelectionText" : MessageLookupByLibrary.simpleMessage("Tap to select"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "catTutorialText" : MessageLookupByLibrary.simpleMessage("Cats are slower than mice.\nWhen a cat meets an arrow head-on, it will damage it or destroy it if already damaged."),
    "challengeGetMiceText" : MessageLookupByLibrary.simpleMessage("Like in Puzzle mode, you need to make all the mice, but as fast as possible this time."),
    "challengeGetMiceType" : MessageLookupByLibrary.simpleMessage("Get Mice"),
    "challengeLunchTimeText" : MessageLookupByLibrary.simpleMessage("No rocket here, feed the cats with every single mouse!"),
    "challengeLunchTimeType" : MessageLookupByLibrary.simpleMessage("Lunch Time"),
    "challengeOneHundredMiceText" : MessageLookupByLibrary.simpleMessage("Mice and cats will naturally spawn, get one hundred of mice!"),
    "challengeOneHundredMiceType" : MessageLookupByLibrary.simpleMessage("One Hundred Mice"),
    "challengeRunAwayType" : MessageLookupByLibrary.simpleMessage("Run Away"),
    "challengeTutorialText" : MessageLookupByLibrary.simpleMessage("Challenges are fast-paced games where you only have 30 seconds to complete an objective that depends on the type of the challenge.\n\nUnlike Puzzle mode, you can place as many arrows as you want but they expire after 10 seconds and there can only be 3 arrows at a time (placing more will replace the oldest)."),
    "challengeType" : MessageLookupByLibrary.simpleMessage("Challenge"),
    "challengesTitle" : MessageLookupByLibrary.simpleMessage("Challenges"),
    "communityTab" : MessageLookupByLibrary.simpleMessage("Community"),
    "completedPercentLabel" : m0,
    "confirmLabel" : MessageLookupByLibrary.simpleMessage("Confirm"),
    "connectedStatusLabel" : MessageLookupByLibrary.simpleMessage("Connected"),
    "connectingToServerText" : MessageLookupByLibrary.simpleMessage("Connecting to server..."),
    "contributingTab" : MessageLookupByLibrary.simpleMessage("Contributing"),
    "contributingText" : MessageLookupByLibrary.simpleMessage("Help NyaNya Rocket!\n\nYou don\'t need any particular skills to contribute, you can:\n  • Report bugs and ask for new features\n  • Translate\n  • Improve graphical assets and animation\n  • Code\n\nFor more information, head over to "),
    "contributorsLabel" : MessageLookupByLibrary.simpleMessage("Contributors"),
    "createLabel" : MessageLookupByLibrary.simpleMessage("Create"),
    "darkModeLabel" : MessageLookupByLibrary.simpleMessage("Dark Mode"),
    "dateLabel" : MessageLookupByLibrary.simpleMessage("Date"),
    "deny" : MessageLookupByLibrary.simpleMessage("Deny"),
    "deviceTab" : MessageLookupByLibrary.simpleMessage("Device"),
    "discardDialogMessage" : MessageLookupByLibrary.simpleMessage("Are you sure you want to leave?\nAny unsaved changes will be discarded!"),
    "discardDialogTitle" : MessageLookupByLibrary.simpleMessage("Confirm leave"),
    "disconnectedStatusLabel" : MessageLookupByLibrary.simpleMessage("Disconnected"),
    "displayNameChangeSuccessText" : MessageLookupByLibrary.simpleMessage("Display name successfully changed!"),
    "displayNameDialogTitle" : MessageLookupByLibrary.simpleMessage("Please enter your new display name"),
    "displayNameFormatText" : MessageLookupByLibrary.simpleMessage("Between 2 and 24 characters (no space)."),
    "displayNameLabel" : MessageLookupByLibrary.simpleMessage("Display name"),
    "duelLabel" : MessageLookupByLibrary.simpleMessage("Duel"),
    "easyLabel" : MessageLookupByLibrary.simpleMessage("Easy"),
    "editTab" : MessageLookupByLibrary.simpleMessage("Edit"),
    "editorTitle" : MessageLookupByLibrary.simpleMessage("Editor"),
    "emptyListText" : MessageLookupByLibrary.simpleMessage("Nothing here..."),
    "enableAnimationsLabel" : MessageLookupByLibrary.simpleMessage("Enable Animations"),
    "entitiesTutorialLabel" : MessageLookupByLibrary.simpleMessage("Entities"),
    "firstTimeButtonLabel" : MessageLookupByLibrary.simpleMessage("Take me to it!"),
    "firstTimeText" : MessageLookupByLibrary.simpleMessage("First time here? Check the tutorial!"),
    "firstTimeWelcome" : MessageLookupByLibrary.simpleMessage("Welcome,"),
    "fourPlayersLabel" : MessageLookupByLibrary.simpleMessage("4-players battle"),
    "generalLabel" : MessageLookupByLibrary.simpleMessage("General"),
    "getMiceObjectiveText" : MessageLookupByLibrary.simpleMessage("Lead all mice to the goal within 30 sec."),
    "hardLabel" : MessageLookupByLibrary.simpleMessage("Hard"),
    "homeTitle" : MessageLookupByLibrary.simpleMessage("Home"),
    "hostnameLabel" : MessageLookupByLibrary.simpleMessage("Server hostname"),
    "intermediateLabel" : MessageLookupByLibrary.simpleMessage("Intermediate"),
    "invalidDisplayNameError" : MessageLookupByLibrary.simpleMessage("Error: The provided display name is invalid!"),
    "invalidHostnameText" : MessageLookupByLibrary.simpleMessage("Please enter a valid hostname."),
    "invalidNameText" : MessageLookupByLibrary.simpleMessage("Please enter a valid name."),
    "invalidNicknameText" : MessageLookupByLibrary.simpleMessage("Please enter a valid nickname."),
    "joinQueueLabel" : MessageLookupByLibrary.simpleMessage("Join"),
    "lanTab" : MessageLookupByLibrary.simpleMessage("LAN"),
    "languageLabel" : MessageLookupByLibrary.simpleMessage("Language"),
    "loadingLabel" : MessageLookupByLibrary.simpleMessage("Loading..."),
    "localDuelTab" : MessageLookupByLibrary.simpleMessage("Local Duel"),
    "loginPromptText" : MessageLookupByLibrary.simpleMessage("Please sign-in first! (Settings—Account Management)"),
    "loginStatusLabel" : MessageLookupByLibrary.simpleMessage("Login status"),
    "lunchTimeObjectiveText" : MessageLookupByLibrary.simpleMessage("Feed the cat!"),
    "matchmakingTab" : MessageLookupByLibrary.simpleMessage("Matchmaking"),
    "minuteCountLabel" : m1,
    "mouseTutorialText" : MessageLookupByLibrary.simpleMessage("Mouse"),
    "movementTutorialText" : MessageLookupByLibrary.simpleMessage("\nAn entity walks straight until it encounters an arrow or a wall.\nFor some reasons, mice and cats prefer turning right when hitting a wall...\n"),
    "multiplayerTitle" : MessageLookupByLibrary.simpleMessage("Multiplayer"),
    "multiplayerType" : MessageLookupByLibrary.simpleMessage("Multiplayer"),
    "nameLabel" : MessageLookupByLibrary.simpleMessage("Name"),
    "newTab" : MessageLookupByLibrary.simpleMessage("New"),
    "newsLabel" : MessageLookupByLibrary.simpleMessage("News"),
    "nextLevelLabel" : MessageLookupByLibrary.simpleMessage("Next level"),
    "nicknameLabel" : MessageLookupByLibrary.simpleMessage("Nickname"),
    "no" : MessageLookupByLibrary.simpleMessage("No"),
    "notImplementedText" : MessageLookupByLibrary.simpleMessage("Not (yet) available!\nWant it to be a priority? :-)"),
    "oneHundredMiceObjectiveText" : MessageLookupByLibrary.simpleMessage("Collect 100 mice in 30 sec."),
    "originalTab" : MessageLookupByLibrary.simpleMessage("Original"),
    "pitTutorialText" : MessageLookupByLibrary.simpleMessage("Black Hole (technically a square though...)"),
    "placementTutorialLabel" : MessageLookupByLibrary.simpleMessage("Arrow placement"),
    "playAgainLabel" : MessageLookupByLibrary.simpleMessage("Play again"),
    "playLabel" : MessageLookupByLibrary.simpleMessage("Play"),
    "playerCountLabel" : m2,
    "playersInQueueText" : m3,
    "popularityLabel" : MessageLookupByLibrary.simpleMessage("Popularity"),
    "positionInQueueText" : m4,
    "privacyPolicyLabel" : MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "publishLabel" : MessageLookupByLibrary.simpleMessage("Publish"),
    "publishSuccessText" : MessageLookupByLibrary.simpleMessage("Puzzle published!"),
    "puzzleNotCompletedLocallyText" : MessageLookupByLibrary.simpleMessage("Puzzle not published as you didn\'t complete it"),
    "puzzleTutorialText" : MessageLookupByLibrary.simpleMessage("A Puzzle game is won when every mice has reached a rocket.\nYou have a restricted amount of arrows to achieve that goal.\n\nNote that you cannot place or remove an arrow after pressing the play button; you\'ll need to reset the level first.\n\nYou\'ll lose if:\n  • A cat enters a rocket before every mice is safe.\n  • A mouse gets eaten by a cat.\n  • A mouse falls into a black hole.\n\nYou\'ll be awarded a star if you complete a level without using all the available arrows.\n"),
    "puzzleType" : MessageLookupByLibrary.simpleMessage("Puzzle"),
    "puzzlesTitle" : MessageLookupByLibrary.simpleMessage("Puzzles"),
    "queueRefreshErrorText" : MessageLookupByLibrary.simpleMessage("Error while refreshing queue info."),
    "regionLabel" : MessageLookupByLibrary.simpleMessage("Region"),
    "rocketTutorialText" : MessageLookupByLibrary.simpleMessage("Rocket"),
    "runAwayObjectiveText" : MessageLookupByLibrary.simpleMessage("Avoid the cat and get to the goal!"),
    "saveLabel" : MessageLookupByLibrary.simpleMessage("Save"),
    "settingsTitle" : MessageLookupByLibrary.simpleMessage("Settings"),
    "showCompletedLabel" : MessageLookupByLibrary.simpleMessage("Show Completed"),
    "signInDialogTitle" : MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "signInLabel" : MessageLookupByLibrary.simpleMessage("Tap to sign-in"),
    "signOutDialogText" : MessageLookupByLibrary.simpleMessage("Are you sure you want to sign-out?\n\nYou will lose the ability to publish community challenges and puzzles."),
    "signOutDialogTitle" : MessageLookupByLibrary.simpleMessage("Confirm sign-out"),
    "signOutLabel" : MessageLookupByLibrary.simpleMessage("Tap to sign-out"),
    "sortByLabel" : MessageLookupByLibrary.simpleMessage("Sort by"),
    "stageClearedText" : MessageLookupByLibrary.simpleMessage("Stage cleared!"),
    "tapToChangeDisplayNameLabel" : MessageLookupByLibrary.simpleMessage("Tap to change"),
    "thisDeviceIpText" : m5,
    "tilesTutorialLabel" : MessageLookupByLibrary.simpleMessage("Tiles"),
    "tutorialTitle" : MessageLookupByLibrary.simpleMessage("How to play"),
    "unauthenticatedError" : MessageLookupByLibrary.simpleMessage("Error: Unauthenticated"),
    "veryHardLabel" : MessageLookupByLibrary.simpleMessage("Very Hard"),
    "waitingForPlayersText" : MessageLookupByLibrary.simpleMessage("Waiting for players..."),
    "whatsNewTab" : MessageLookupByLibrary.simpleMessage("What\'s New?"),
    "yes" : MessageLookupByLibrary.simpleMessage("Yes")
  };
}
