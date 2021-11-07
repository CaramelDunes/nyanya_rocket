enum PageKind { home, puzzle, challenge, editor, multiplayer, guide }
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
      case PageKind.guide:
        return 'guide';
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

  const NyaNyaRoutePath(this.kind, this.tabKind, this.id);

  const NyaNyaRoutePath.home()
      : id = null,
        kind = PageKind.home,
        tabKind = null;

  const NyaNyaRoutePath.puzzles()
      : kind = PageKind.puzzle,
        id = null,
        tabKind = null;

  const NyaNyaRoutePath.challenges()
      : kind = PageKind.challenge,
        id = null,
        tabKind = null;

  const NyaNyaRoutePath.editor()
      : kind = PageKind.editor,
        id = null,
        tabKind = null;

  const NyaNyaRoutePath.multiplayer()
      : kind = PageKind.multiplayer,
        id = null,
        tabKind = null;

  const NyaNyaRoutePath.guide()
      : kind = PageKind.guide,
        id = null,
        tabKind = null;

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
