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
import '../screens/puzzles/widgets/original_puzzles.dart';

import '../screens/challenges/tabs/original_challenges.dart';
import '../screens/puzzles/puzzles.dart';
import '../services/firestore/firestore_service.dart';
import 'nyanya_route_path.dart';

class NyaNyaRouterDelegate extends RouterDelegate<NyaNyaRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NyaNyaRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  PageKind _pageKind = PageKind.home;
  TabKind? _tabKind;
  String? _id;

  @override
  NyaNyaRoutePath get currentConfiguration {
    return NyaNyaRoutePath(_pageKind, _tabKind, _id);
  }

  MaterialPage _pageForKind(PageKind pageKind) {
    final TabKind effectiveTabKind = _tabKind ?? TabKind.original;

    switch (pageKind) {
      case PageKind.home:
        return const MaterialPage(key: ValueKey('HomePage'), child: Home());

      case PageKind.puzzle:
        return MaterialPage(
            key: ValueKey('PuzzlesPage${effectiveTabKind.index}'),
            child: Puzzles(initialTab: effectiveTabKind));

      case PageKind.challenge:
        return MaterialPage(
            key: ValueKey('ChallengesPage${effectiveTabKind.index}'),
            child: Challenges(initialTab: effectiveTabKind));

      case PageKind.editor:
        return const MaterialPage(key: ValueKey('EditorPage'), child: Editor());

      case PageKind.multiplayer:
        if (!kIsWeb) {
          return const MaterialPage(
              key: ValueKey('MultiplayerPage'), child: Multiplayer());
        } else {
          return const MaterialPage(
              key: ValueKey('MultiplayerPage'),
              child: MultiplayerNotAvailable());
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_pageKind != PageKind.home) _pageForKind(PageKind.home),
        _pageForKind(_pageKind),
        if (_pageKind == PageKind.puzzle &&
            _id != null &&
            _tabKind == TabKind.original &&
            OriginalPuzzles.slugs.containsKey(_id))
          MaterialPage(
              key: ValueKey('OriginalPuzzle$_id'),
              child: OriginalPuzzle(
                id: OriginalPuzzles.slugs[_id]!,
              ))
        else if (_pageKind == PageKind.challenge &&
            _id != null &&
            _tabKind == TabKind.original &&
            OriginalChallenges.slugs.containsKey(_id))
          MaterialPage(
              key: ValueKey('OriginalChallenge$_id'),
              child: OriginalChallenge(
                id: OriginalChallenges.slugs[_id]!,
              ))
        else if (_pageKind == PageKind.puzzle &&
            _id != null &&
            _tabKind == TabKind.community)
          MaterialPage(
              key: ValueKey('CommunityPuzzle$_id'),
              child: LoadingPuzzle(
                  futurePuzzle: context
                      .read<FirestoreService>()
                      .getCommunityPuzzle(_id!)))
        else if (_pageKind == PageKind.challenge &&
            _id != null &&
            _tabKind == TabKind.community)
          MaterialPage(
              key: ValueKey('CommunityChallenge$_id'),
              child: LoadingChallenge(
                  futureChallenge: context
                      .read<FirestoreService>()
                      .getCommunityChallenge(_id!)))
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if (_id != null) {
          _id = null;
        } else {
          _tabKind = null;
          _pageKind = PageKind.home;
        }

        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(NyaNyaRoutePath configuration) async {
    _pageKind = configuration.kind;
    _tabKind = configuration.tabKind;
    _id = configuration.id;
    notifyListeners();
    return SynchronousFuture(null);
  }

  void setVirtualNewRoutePath(NyaNyaRoutePath configuration) {
    _pageKind = configuration.kind;
    _tabKind = configuration.tabKind;
    _id = configuration.id;
  }
}
