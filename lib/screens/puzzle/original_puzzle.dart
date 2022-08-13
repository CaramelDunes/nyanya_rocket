import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../boards/original_puzzles.dart';
import '../../routing/nyanya_route_path.dart';
import '../puzzles/puzzle_progression_manager.dart';
import 'puzzle.dart';

class OriginalPuzzle extends StatelessWidget {
  final int id;

  const OriginalPuzzle({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Puzzle(
      puzzle: originalPuzzles[id],
      nextRoutePath: id + 1 < originalPuzzles.length
          ? NyaNyaRoutePath.originalPuzzle(originalPuzzles[id + 1].slug)
          : null,
      onWin: (starred) {
        final progression = context.read<PuzzleProgressionManager>();

        progression.setCleared(id);

        if (starred) {
          progression.setStarred(id, starred);
        }
      },
    );
  }
}
