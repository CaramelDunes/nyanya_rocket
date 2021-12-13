enum PageKind { home, puzzle, challenge, editor, multiplayer }
enum TabKind { original, community, local }

extension PageKindSlug on PageKind {
  String get slug {
    switch (this) {
      case PageKind.home:
        return '';
      case PageKind.puzzle:
        return 'puzzles';
      case PageKind.challenge:
        return 'challenges';
      case PageKind.editor:
        return 'editor';
      case PageKind.multiplayer:
        return 'multiplayer';
    }
  }

  static PageKind? fromSlug(String? slug) {
    switch (slug) {
      case 'puzzles':
        return PageKind.puzzle;
      case 'challenges':
        return PageKind.challenge;
      case 'editor':
        return PageKind.editor;
      case 'multiplayer':
        return PageKind.multiplayer;
    }
  }
}

extension TabKindSlug on TabKind {
  String get slug {
    switch (this) {
      case TabKind.original:
        return 'original';
      case TabKind.community:
        return 'community';
      case TabKind.local:
        return 'local';
    }
  }

  static TabKind? fromSlug(String? slug) {
    switch (slug) {
      case 'original':
        return TabKind.original;
      case 'community':
        return TabKind.community;
      case 'local':
        return TabKind.local;
    }
  }
}

class NyaNyaRoutePath {
  final PageKind kind;
  final TabKind? tabKind;
  final String? id;

  NyaNyaRoutePath(this.kind, TabKind? tabKind, String? id)
      : tabKind = _maybeStrip(kind, tabKind),
        id = tabKind == null ? null : _maybeStrip(kind, id);

  static T? _maybeStrip<T>(PageKind kind, T? tabOrId) {
    // Editor route doesn't have tabs nor ids.
    if (kind == PageKind.editor) {
      return null;
    }

    return tabOrId;
  }

  const NyaNyaRoutePath.home()
      : id = null,
        kind = PageKind.home,
        tabKind = null;

  const NyaNyaRoutePath.editor()
      : kind = PageKind.editor,
        id = null,
        tabKind = null;

  const NyaNyaRoutePath.multiplayer()
      : kind = PageKind.multiplayer,
        id = null,
        tabKind = null;

  const NyaNyaRoutePath.originalPuzzles()
      : kind = PageKind.puzzle,
        tabKind = TabKind.original,
        id = null;

  const NyaNyaRoutePath.communityPuzzles()
      : kind = PageKind.puzzle,
        tabKind = TabKind.community,
        id = null;

  const NyaNyaRoutePath.localPuzzles()
      : kind = PageKind.puzzle,
        tabKind = TabKind.local,
        id = null;

  const NyaNyaRoutePath.originalChallenges()
      : kind = PageKind.challenge,
        tabKind = TabKind.original,
        id = null;

  const NyaNyaRoutePath.communityChallenges()
      : kind = PageKind.challenge,
        tabKind = TabKind.community,
        id = null;

  const NyaNyaRoutePath.localChallenges()
      : kind = PageKind.challenge,
        tabKind = TabKind.local,
        id = null;

  NyaNyaRoutePath.originalPuzzle(this.id)
      : kind = PageKind.puzzle,
        tabKind = TabKind.original;

  NyaNyaRoutePath.communityPuzzle(this.id)
      : kind = PageKind.puzzle,
        tabKind = TabKind.community;

  NyaNyaRoutePath.originalChallenge(this.id)
      : kind = PageKind.challenge,
        tabKind = TabKind.original;

  NyaNyaRoutePath.communityChallenge(this.id)
      : kind = PageKind.challenge,
        tabKind = TabKind.community;
}
