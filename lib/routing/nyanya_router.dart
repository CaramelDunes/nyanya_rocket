import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/challenges/challenges.dart';
import 'package:nyanya_rocket/screens/editor/editor.dart';
import 'package:nyanya_rocket/screens/home/home.dart';
import 'package:nyanya_rocket/screens/multiplayer/multiplayer.dart';
import '../screens/puzzle/puzzle.dart';
import '../screens/puzzles/widgets/original_puzzles.dart';
import '../screens/tutorial/tutorial.dart';

import '../screens/challenge/challenge.dart';
import '../screens/challenges/tabs/original_challenges.dart';
import '../screens/puzzles/puzzles.dart';
import 'nyanya_route_path.dart';

class NyaNyaRouterDelegate extends RouterDelegate<NyaNyaRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NyaNyaRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  PageKind _pageKind = PageKind.Home;
  String? _id;

  NyaNyaRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  NyaNyaRoutePath get currentConfiguration {
    return NyaNyaRoutePath(_pageKind, _id);
  }

  MaterialPage _pageForKind(PageKind pageKind) {
    switch (pageKind) {
      case PageKind.Home:
        return MaterialPage(key: ValueKey('HomePage'), child: Home());

      case PageKind.Puzzle:
      case PageKind.Puzzles:
        return MaterialPage(key: ValueKey('PuzzlesPage'), child: Puzzles());

      case PageKind.Challenge:
        return MaterialPage(
            key: ValueKey('ChallengesPage'), child: Challenges());

      case PageKind.Editor:
        return MaterialPage(key: ValueKey('EditorPage'), child: Editor());

      case PageKind.Multiplayer:
        return MaterialPage(
            key: ValueKey('MultiplayerPage'), child: Multiplayer());

      case PageKind.Guide:
        return MaterialPage(key: ValueKey('TutorialPage'), child: Tutorial());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        _pageForKind(_pageKind),
        if (_pageKind == PageKind.Puzzle && _id != null)
          MaterialPage(
              key: ValueKey('PuzzlePage$_id'),
              child: Puzzle(
                puzzle: OriginalPuzzles.puzzles[int.parse(_id!)],
                hasNext: false,
              ))
        else if (_pageKind == PageKind.Challenge && _id != null)
          MaterialPage(
              key: ValueKey('ChallengePage$_id'),
              child: Challenge(
                challenge: OriginalChallenges.challenges[int.parse(_id!)],
                hasNext: false,
              ))
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(NyaNyaRoutePath path) async {
    _pageKind = path.kind;
    _id = path.id;
    notifyListeners();
    return SynchronousFuture(null);
  }
}
