enum PageKind { Home, Puzzle, Challenge, Editor, Multiplayer, Guide }
enum TabKind { Original, Community, Local }

extension PageKindSlug on PageKind {
  String get slug {
    switch (this) {
      case PageKind.Home:
        return '';
      case PageKind.Puzzle:
        return 'puzzles';
      case PageKind.Challenge:
        return 'challenges';
      case PageKind.Editor:
        return 'editor';
      case PageKind.Multiplayer:
        return 'multiplayer';
      case PageKind.Guide:
        return 'guide';
    }
  }

  static PageKind? fromSlug(String? slug) {
    switch (slug) {
      case 'puzzles':
        return PageKind.Puzzle;
      case 'challenges':
        return PageKind.Challenge;
      case 'editor':
        return PageKind.Editor;
    }
  }
}

extension TabKindSlug on TabKind {
  String get slug {
    switch (this) {
      case TabKind.Original:
        return 'original';
      case TabKind.Community:
        return 'community';
      case TabKind.Local:
        return 'local';
    }
  }

  static TabKind? fromSlug(String? slug) {
    switch (slug) {
      case 'original':
        return TabKind.Original;
      case 'community':
        return TabKind.Community;
      case 'local':
        return TabKind.Local;
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
        kind = PageKind.Home,
        tabKind = null;

  const NyaNyaRoutePath.puzzles()
      : kind = PageKind.Puzzle,
        this.id = null,
        tabKind = null;

  const NyaNyaRoutePath.challenges()
      : kind = PageKind.Challenge,
        this.id = null,
        tabKind = null;

  const NyaNyaRoutePath.editor()
      : kind = PageKind.Editor,
        this.id = null,
        tabKind = null;

  const NyaNyaRoutePath.multiplayer()
      : kind = PageKind.Multiplayer,
        this.id = null,
        tabKind = null;

  const NyaNyaRoutePath.guide()
      : kind = PageKind.Guide,
        this.id = null,
        tabKind = null;

  NyaNyaRoutePath.originalPuzzle(this.id)
      : kind = PageKind.Puzzle,
        tabKind = TabKind.Original;

  NyaNyaRoutePath.communityPuzzle(this.id)
      : kind = PageKind.Puzzle,
        tabKind = TabKind.Community;

  NyaNyaRoutePath.originalChallenge(this.id)
      : kind = PageKind.Challenge,
        tabKind = TabKind.Original;

  NyaNyaRoutePath.communityChallenge(this.id)
      : kind = PageKind.Challenge,
        tabKind = TabKind.Community;
}
