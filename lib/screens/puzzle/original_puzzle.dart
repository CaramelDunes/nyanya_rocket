import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/named_puzzle_data.dart';
import '../../routing/nyanya_route_path.dart';
import '../puzzles/puzzle_progression_manager.dart';
import '../puzzles/widgets/original_puzzles.dart';
import 'puzzle.dart';

class OriginalPuzzle extends StatelessWidget {
  final int id;

  const OriginalPuzzle({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Puzzle(
      puzzle: NamedPuzzleData.fromJson(jsonDecode(OriginalPuzzles.jsons[id])),
      nextRoutePath: id + 1 < OriginalPuzzles.puzzles.length
          ? NyaNyaRoutePath.originalPuzzle(OriginalPuzzles.puzzles[id + 1].slug)
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
