import 'package:flutter/material.dart';

import '../../routing/nyanya_route_path.dart';
import '../puzzles/puzzle_progression_manager.dart';
import '../puzzles/widgets/original_puzzles.dart';
import 'puzzle.dart';

class OriginalPuzzle extends StatelessWidget {
  final int id;

  const OriginalPuzzle({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Puzzle(
      puzzle: OriginalPuzzles.puzzles[id],
      nextRoutePath: id + 1 < OriginalPuzzles.puzzles.length
          ? NyaNyaRoutePath.originalPuzzle(OriginalPuzzles.puzzles[id + 1].slug)
          : null,
      onWin: (starred) {
        PuzzleProgressionManager.setCleared(id);

        if (starred) {
          PuzzleProgressionManager.setStarred(id, starred);
        }
      },
    );
  }
}
