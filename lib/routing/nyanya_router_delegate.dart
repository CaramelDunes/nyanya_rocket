import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nyanya_rocket/screens/challenge/loading_challenge.dart';
import 'package:nyanya_rocket/screens/challenge/original_challenge.dart';
import 'package:nyanya_rocket/screens/challenges/challenges.dart';
import 'package:nyanya_rocket/screens/editor/editor.dart';
import 'package:nyanya_rocket/screens/home/home.dart';
import 'package:nyanya_rocket/screens/multiplayer/multiplayer.dart';
import 'package:nyanya_rocket/screens/multiplayer/multiplayer_not_available.dart';
import 'package:nyanya_rocket/screens/puzzle/loading_puzzle.dart';
import 'package:nyanya_rocket/screens/puzzle/original_puzzle.dart';
import 'package:nyanya_rocket/services/firebase/firebase_service.dart';
import '../screens/puzzles/widgets/original_puzzles.dart';
import '../screens/tutorial/tutorial.dart';

import '../screens/challenges/tabs/original_challenges.dart';
import '../screens/puzzles/puzzles.dart';
import 'nyanya_route_path.dart';

class NyaNyaRouterDelegate extends RouterDelegate<NyaNyaRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NyaNyaRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  PageKind _pageKind = PageKind.Home;
  TabKind? _tabKind;
  String? _id;

  NyaNyaRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  NyaNyaRoutePath get currentConfiguration {
    return NyaNyaRoutePath(_pageKind, _tabKind, _id);
  }

  MaterialPage _pageForKind(PageKind pageKind) {
    switch (pageKind) {
      case PageKind.Home:
        return MaterialPage(key: ValueKey('HomePage'), child: Home());

      case PageKind.Puzzle:
        return MaterialPage(
            key: ValueKey('PuzzlesPage'),
            child: Puzzles(initialTab: _tabKind ?? TabKind.Original));

      case PageKind.Challenge:
        return MaterialPage(
            key: ValueKey('ChallengesPage'),
            child: Challenges(initialTab: _tabKind ?? TabKind.Original));

      case PageKind.Editor:
        return MaterialPage(key: ValueKey('EditorPage'), child: Editor());

      case PageKind.Multiplayer:
        if (!kIsWeb)
          return MaterialPage(
              key: ValueKey('MultiplayerPage'), child: Multiplayer());
        else
          return MaterialPage(
              key: ValueKey('MultiplayerPage'),
              child: MultiplayerNotAvailable());

      case PageKind.Guide:
        return MaterialPage(key: ValueKey('TutorialPage'), child: Tutorial());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_pageKind != PageKind.Home) _pageForKind(PageKind.Home),
        _pageForKind(_pageKind),
        if (_pageKind == PageKind.Puzzle &&
            _id != null &&
            _tabKind == TabKind.Original &&
            OriginalPuzzles.slugs.containsKey(_id))
          MaterialPage(
              key: ValueKey('OriginalPuzzle$_id'),
              child: OriginalPuzzle(
                id: OriginalPuzzles.slugs[_id]!,
              ))
        else if (_pageKind == PageKind.Challenge &&
            _id != null &&
            _tabKind == TabKind.Original &&
            OriginalChallenges.slugs.containsKey(_id))
          MaterialPage(
              key: ValueKey('OriginalChallenge$_id'),
              child: OriginalChallenge(
                id: OriginalChallenges.slugs[_id]!,
              ))
        else if (_pageKind == PageKind.Puzzle &&
            _id != null &&
            _tabKind == TabKind.Community)
          MaterialPage(
              key: ValueKey('CommunityPuzzle$_id'),
              child: LoadingPuzzle(
                  futurePuzzle:
                      context.read<FirebaseService>().getCommunityPuzzle(_id!)))
        else if (_pageKind == PageKind.Challenge &&
            _id != null &&
            _tabKind == TabKind.Community)
          MaterialPage(
              key: ValueKey('CommunityChallenge$_id'),
              child: LoadingChallenge(
                  futureChallenge: context
                      .read<FirebaseService>()
                      .getCommunityChallenge(_id!)))
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (_id != null) {
          _id = null;
        } else if (_tabKind != null) {
          _tabKind = null;
        } else {
          _pageKind = PageKind.Home;
        }

        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(NyaNyaRoutePath path) async {
    _pageKind = path.kind;
    _tabKind = path.tabKind;
    _id = path.id;
    notifyListeners();
    return SynchronousFuture(null);
  }
}
