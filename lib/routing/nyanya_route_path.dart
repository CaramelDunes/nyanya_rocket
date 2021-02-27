enum PageKind { Home, Puzzle, Puzzles, Challenge, Editor, Multiplayer, Guide }

class NyaNyaRoutePath {
  final PageKind kind;
  final String? id;

  NyaNyaRoutePath(this.kind, this.id);

  NyaNyaRoutePath.home()
      : id = null,
        kind = PageKind.Home;

  NyaNyaRoutePath.puzzles()
      : kind = PageKind.Puzzles,
        this.id = null;

  NyaNyaRoutePath.challenges()
      : kind = PageKind.Challenge,
        this.id = null;

  NyaNyaRoutePath.editor()
      : kind = PageKind.Editor,
        this.id = null;

  NyaNyaRoutePath.multiplayer()
      : kind = PageKind.Multiplayer,
        this.id = null;

  NyaNyaRoutePath.guide()
      : kind = PageKind.Guide,
        this.id = null;

  NyaNyaRoutePath.puzzle(this.id) : kind = PageKind.Puzzle;

  NyaNyaRoutePath.challenge(this.id) : kind = PageKind.Challenge;
}
