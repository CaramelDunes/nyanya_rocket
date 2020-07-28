// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static m0(percentCompleted) => "${percentCompleted}% réussis";

  static m1(minuteCount) => "${minuteCount} minutes";

  static m2(playerCount) => "${playerCount} joueurs";

  static m3(queueLength) => "${queueLength} joueurs dans la file d\'attente.";

  static m4(position, queueLength) => "Position dans la file d\'attente: ${position} / ${queueLength}";

  static m5(localIp) => "Votre adresse IP: ${localIp}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "accept" : MessageLookupByLibrary.simpleMessage("Accepter"),
    "accountManagementLabel" : MessageLookupByLibrary.simpleMessage("Gestion de compte"),
    "arrowDnDTutorialText" : MessageLookupByLibrary.simpleMessage("Les flèches peuvent être glissées-déposées..."),
    "arrowRemoveTutorialText" : MessageLookupByLibrary.simpleMessage("En mode puzzle, les flèches peuvent être retirées en tappant dessus."),
    "arrowSwipeTutorialText" : MessageLookupByLibrary.simpleMessage("...ou simplement glissées"),
    "arrowTutorialText" : MessageLookupByLibrary.simpleMessage("Flèche"),
    "awaitingForPlayersLabel" : MessageLookupByLibrary.simpleMessage("En attente de joueurs..."),
    "back" : MessageLookupByLibrary.simpleMessage("Retour"),
    "boardLabel" : MessageLookupByLibrary.simpleMessage("Plateau"),
    "boardSelectionText" : MessageLookupByLibrary.simpleMessage("Toucher pour sélectionner un plateau de jeu"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Annuler"),
    "catTutorialText" : MessageLookupByLibrary.simpleMessage("Les chats sont plus lents que les souris.\nQuand un chat rencontre une flèche de face, il l\'endommage ou la détruit si elle a déjà été endommagée."),
    "challengeGetMiceText" : MessageLookupByLibrary.simpleMessage("Mêmes règles que le mode Puzzle, sauvez toutes les souris mais le plus vite possible cette fois !"),
    "challengeGetMiceType" : MessageLookupByLibrary.simpleMessage("Attrapez-les toutes"),
    "challengeLunchTimeText" : MessageLookupByLibrary.simpleMessage("Aucune échappatoire possible, toutes les souris doivent finir dévorées par les chats."),
    "challengeLunchTimeType" : MessageLookupByLibrary.simpleMessage("À table !"),
    "challengeOneHundredMiceText" : MessageLookupByLibrary.simpleMessage("Les chats et les souris apparaissent naturellement, tachez d\'attraper 100 souris."),
    "challengeOneHundredMiceType" : MessageLookupByLibrary.simpleMessage("100 souris"),
    "challengeRunAwayType" : MessageLookupByLibrary.simpleMessage("Aux abris !"),
    "challengeTutorialText" : MessageLookupByLibrary.simpleMessage("Les Défis sont des mini-jeux de haute intensité ou vous n\'avez que 30 secondes pour remplir un objectif.\n\nLe placement des flèches est différent de celui du mode Puzzle. En effet, vous pouvez placer autant de flèches que vous voulez mais seulement 3 peuvent être actives en même temps."),
    "challengeType" : MessageLookupByLibrary.simpleMessage("Défi"),
    "challengesTitle" : MessageLookupByLibrary.simpleMessage("Défis"),
    "communityTab" : MessageLookupByLibrary.simpleMessage("Communauté"),
    "completedPercentLabel" : m0,
    "confirmLabel" : MessageLookupByLibrary.simpleMessage("Confirmer"),
    "connectedStatusLabel" : MessageLookupByLibrary.simpleMessage("Connecté"),
    "connectingToServerText" : MessageLookupByLibrary.simpleMessage("Connexion au serveur..."),
    "contributingTab" : MessageLookupByLibrary.simpleMessage("Participer"),
    "contributingText" : MessageLookupByLibrary.simpleMessage("Vous aussi contribuez à NyaNya Rocket !\n\nPas besoin de savoir programmer ou d\'être exposé au Louvre, toute contribution est la bienvenue. Vous pouvez:\n  • Signaler des bugs et proposer des améliorations\n  • Traduire l\'application dans d\'autres langues\n  • Améliorer le contenu artistique (images, animations)\n  • Programmer\n\nPour plus d\'informations, rendez-vous sur "),
    "contributorsLabel" : MessageLookupByLibrary.simpleMessage("Contributeurs"),
    "createLabel" : MessageLookupByLibrary.simpleMessage("Créer"),
    "darkModeLabel" : MessageLookupByLibrary.simpleMessage("Mode nuit"),
    "dateLabel" : MessageLookupByLibrary.simpleMessage("Date"),
    "deny" : MessageLookupByLibrary.simpleMessage("Refuser"),
    "deviceTab" : MessageLookupByLibrary.simpleMessage("Local"),
    "discardDialogMessage" : MessageLookupByLibrary.simpleMessage("Êtes-vous sûr(e) de vouloir terminer l\'édition ?\nToute modification non sauvegardée sera perdue."),
    "discardDialogTitle" : MessageLookupByLibrary.simpleMessage("Confirmation"),
    "disconnectedStatusLabel" : MessageLookupByLibrary.simpleMessage("Déconnecté"),
    "displayNameChangeSuccessText" : MessageLookupByLibrary.simpleMessage("Changement de pseudo réussi !"),
    "displayNameDialogTitle" : MessageLookupByLibrary.simpleMessage("Changement de pseudo"),
    "displayNameFormatText" : MessageLookupByLibrary.simpleMessage("Entre 2 et 24 caractères (sans espace)."),
    "displayNameLabel" : MessageLookupByLibrary.simpleMessage("Pseudo"),
    "duelLabel" : MessageLookupByLibrary.simpleMessage("Duel"),
    "durationLabel" : MessageLookupByLibrary.simpleMessage("Durée"),
    "easyLabel" : MessageLookupByLibrary.simpleMessage("Facile"),
    "editTab" : MessageLookupByLibrary.simpleMessage("Modifier"),
    "editorTitle" : MessageLookupByLibrary.simpleMessage("Éditeur"),
    "emptyListText" : MessageLookupByLibrary.simpleMessage("Il n\'y a rien ici..."),
    "enableAnimationsLabel" : MessageLookupByLibrary.simpleMessage("Animations"),
    "entitiesTutorialLabel" : MessageLookupByLibrary.simpleMessage("Personnages"),
    "findPlayersLabel" : MessageLookupByLibrary.simpleMessage("Recherche de joueurs"),
    "firstTimeButtonLabel" : MessageLookupByLibrary.simpleMessage("C\'est parti !"),
    "firstTimeText" : MessageLookupByLibrary.simpleMessage("Première visite ? Allez voir le guide de jeu !"),
    "firstTimeWelcome" : MessageLookupByLibrary.simpleMessage("Bienvenue !"),
    "fourPlayersLabel" : MessageLookupByLibrary.simpleMessage("4 joueurs"),
    "friendDuelLabel" : MessageLookupByLibrary.simpleMessage("Duel ami"),
    "generalLabel" : MessageLookupByLibrary.simpleMessage("Général"),
    "getMiceObjectiveText" : MessageLookupByLibrary.simpleMessage("Guidez toutes les souris vers les fusées en 30 secondes."),
    "hardLabel" : MessageLookupByLibrary.simpleMessage("Difficile"),
    "homeTitle" : MessageLookupByLibrary.simpleMessage("Accueil"),
    "hostnameLabel" : MessageLookupByLibrary.simpleMessage("Adresse du serveur"),
    "intermediateLabel" : MessageLookupByLibrary.simpleMessage("Moyen"),
    "invalidDisplayNameError" : MessageLookupByLibrary.simpleMessage("Erreur: Le pseudo fourni est invalide."),
    "invalidHostnameText" : MessageLookupByLibrary.simpleMessage("Adresse invalide"),
    "invalidNameText" : MessageLookupByLibrary.simpleMessage("Nom invalide (entrez entre 2 et 24 caractères alphanumériques)."),
    "invalidNicknameText" : MessageLookupByLibrary.simpleMessage("Pseudo invalide."),
    "joinQueueLabel" : MessageLookupByLibrary.simpleMessage("Rejoindre"),
    "joinRoomLabel" : MessageLookupByLibrary.simpleMessage("Rejoindre un ami"),
    "languageLabel" : MessageLookupByLibrary.simpleMessage("Langue"),
    "leaderBoardLabel" : MessageLookupByLibrary.simpleMessage("Classement"),
    "loadingLabel" : MessageLookupByLibrary.simpleMessage("Chargement..."),
    "loginPromptText" : MessageLookupByLibrary.simpleMessage("Veuillez vous connecter avant (Paramètres—Gestion de compte)"),
    "loginStatusLabel" : MessageLookupByLibrary.simpleMessage("Statut"),
    "lunchTimeObjectiveText" : MessageLookupByLibrary.simpleMessage("Donnez toutes les souris à manger au(x) chat(s)."),
    "matchmakingTab" : MessageLookupByLibrary.simpleMessage("Monde"),
    "minuteCountLabel" : m1,
    "mouseTutorialText" : MessageLookupByLibrary.simpleMessage("Souris"),
    "movementTutorialText" : MessageLookupByLibrary.simpleMessage("\nLes entités avancent tout droit jusqu\'à rencontrer un mur ou une flèche.\nPour une raison mystérieuse, les souris et les chats préfèrent tourner à droite lorsqu\'ils rencontrent un mur."),
    "multiplayerTitle" : MessageLookupByLibrary.simpleMessage("Multijoueur"),
    "multiplayerType" : MessageLookupByLibrary.simpleMessage("Multijoueur"),
    "nameLabel" : MessageLookupByLibrary.simpleMessage("Nom"),
    "newTab" : MessageLookupByLibrary.simpleMessage("Créer"),
    "newsLabel" : MessageLookupByLibrary.simpleMessage("Actualités"),
    "nextLevelLabel" : MessageLookupByLibrary.simpleMessage("Niveau suivant"),
    "nicknameLabel" : MessageLookupByLibrary.simpleMessage("Pseudo"),
    "nicknamesLabel" : MessageLookupByLibrary.simpleMessage("Pseudos"),
    "no" : MessageLookupByLibrary.simpleMessage("Non"),
    "notImplementedText" : MessageLookupByLibrary.simpleMessage("Pas encore disponible !\n...mais vous pouvez donner un coup de pouce :-)"),
    "oneHundredMiceObjectiveText" : MessageLookupByLibrary.simpleMessage("Sauvez 100 souris en 30 secondes !"),
    "originalTab" : MessageLookupByLibrary.simpleMessage("Originaux"),
    "pitTutorialText" : MessageLookupByLibrary.simpleMessage("Trou noir (un trou carré, certes...)"),
    "placementTutorialLabel" : MessageLookupByLibrary.simpleMessage("Placement des flèches"),
    "playAgainLabel" : MessageLookupByLibrary.simpleMessage("Rejouer"),
    "playLabel" : MessageLookupByLibrary.simpleMessage("Jouer"),
    "playerCountLabel" : m2,
    "playersInQueueText" : m3,
    "popularityLabel" : MessageLookupByLibrary.simpleMessage("Popularité"),
    "positionInQueueText" : m4,
    "privacyPolicyLabel" : MessageLookupByLibrary.simpleMessage("Politique de confidentialité"),
    "publishLabel" : MessageLookupByLibrary.simpleMessage("Publier"),
    "publishSuccessText" : MessageLookupByLibrary.simpleMessage("Puzzle publié !"),
    "puzzleNotCompletedLocallyText" : MessageLookupByLibrary.simpleMessage("Puzzle non publié car non résolu... :-("),
    "puzzleTutorialText" : MessageLookupByLibrary.simpleMessage("En mode puzzle, l\'objectif est de sauver toutes les souris sans exception.\nPour ce faire, vous avez un nombre limité de flèches à disposition.\n\nCes flèches ne peuvent être placées et retirées qu\'avant le lancement de la simulation.\n\nVous perdez si:\n  • Un chat entre dans une fusée avant que toutes les souris ne soient à l\'abris.\n  • Une souris se fait dévorer par un chat.\n  • Une souris tombe dans un trou noir.\n\nCertains niveaux peuvent être terminés en utilisant moins de flèches que disponible, vous obtiendrez une étoile dans ce cas.\n"),
    "puzzleType" : MessageLookupByLibrary.simpleMessage("Puzzle"),
    "puzzlesTitle" : MessageLookupByLibrary.simpleMessage("Puzzles"),
    "queueRefreshErrorText" : MessageLookupByLibrary.simpleMessage("Erreur lors du rafraîchissment\ndu nombre de joueurs dans la file."),
    "refreshLabel" : MessageLookupByLibrary.simpleMessage("Actualiser"),
    "regionLabel" : MessageLookupByLibrary.simpleMessage("Région"),
    "rocketTutorialText" : MessageLookupByLibrary.simpleMessage("Fusée"),
    "roomCodeLabel" : MessageLookupByLibrary.simpleMessage("Code joueur"),
    "roomCodeRetrievalErrorText" : MessageLookupByLibrary.simpleMessage("Impossible de récupérer le code joueur"),
    "runAwayObjectiveText" : MessageLookupByLibrary.simpleMessage("Guidez toutes les souris vers les fusées en évitant les chats !"),
    "saveLabel" : MessageLookupByLibrary.simpleMessage("Sauvegarder"),
    "settingsTitle" : MessageLookupByLibrary.simpleMessage("Paramètres"),
    "showCompletedLabel" : MessageLookupByLibrary.simpleMessage("Montrer réussis"),
    "signInDialogTitle" : MessageLookupByLibrary.simpleMessage("Politique de Confidentialité"),
    "signInLabel" : MessageLookupByLibrary.simpleMessage("Taper pour se connecter"),
    "signOutDialogText" : MessageLookupByLibrary.simpleMessage("Êtes-vous sûr(e) de vouloir vous déconnecter ?\n\nVous ne pourrez plus publier de puzzles et défis."),
    "signOutDialogTitle" : MessageLookupByLibrary.simpleMessage("Déconnexion"),
    "signOutLabel" : MessageLookupByLibrary.simpleMessage("Taper pour se déconnecter"),
    "sortByLabel" : MessageLookupByLibrary.simpleMessage("Trier par"),
    "stageClearedText" : MessageLookupByLibrary.simpleMessage("Niveau réussi !"),
    "tapToChangeDisplayNameLabel" : MessageLookupByLibrary.simpleMessage("Taper pour changer"),
    "thisDeviceIpText" : m5,
    "tilesTutorialLabel" : MessageLookupByLibrary.simpleMessage("Cases"),
    "tutorialTitle" : MessageLookupByLibrary.simpleMessage("Guide de jeu"),
    "unauthenticatedError" : MessageLookupByLibrary.simpleMessage("Erreur: Vous n\'êtes pas connecté"),
    "veryHardLabel" : MessageLookupByLibrary.simpleMessage("Très difficile"),
    "waitingForPlayersText" : MessageLookupByLibrary.simpleMessage("En attente d\'autres joueurs..."),
    "whatsNewTab" : MessageLookupByLibrary.simpleMessage("Quoi de neuf ?"),
    "yes" : MessageLookupByLibrary.simpleMessage("Oui"),
    "yourRoomCodeLabel" : MessageLookupByLibrary.simpleMessage("Votre code joueur est")
  };
}
