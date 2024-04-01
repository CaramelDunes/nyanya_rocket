import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/widgets/navigation/completion_indicator.dart';

import '../../../boards/original_puzzles.dart';
import '../../../widgets/layout/board_card.dart';
import '../../../widgets/layout/board_list.dart';
import '../puzzle_progression_manager.dart';

class OriginalPuzzles extends StatefulWidget {
  const OriginalPuzzles({super.key});

  @override
  State<OriginalPuzzles> createState() => _OriginalPuzzlesState();
}

class _OriginalPuzzlesState extends State<OriginalPuzzles>
    with AutomaticKeepAliveClientMixin<OriginalPuzzles> {
  bool _showCompleted = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    List<int> puzzleIndices =
        Iterable<int>.generate(originalPuzzles.length).toList();

    final progression = context.watch<PuzzleProgressionManager>();
    final cleared = progression.getCleared();
    final starred = progression.getStarred();

    if (!_showCompleted) {
      puzzleIndices = SplayTreeSet<int>.from(puzzleIndices)
          .difference(cleared)
          .toList(growable: false);
    }

    return Column(
      children: [
        Expanded(
          child: BoardList(
            itemCount: puzzleIndices.length,
            tileBuilder: (BuildContext context, int i) => _buildPuzzleTile(
                puzzleIndices[i],
                cleared.contains(puzzleIndices[i]),
                starred.contains(puzzleIndices[i])),
            cardBuilder: (BuildContext context, int i) => _buildPuzzleCard(
                puzzleIndices[i], cleared.contains(puzzleIndices[i])),
          ),
        ),
        CompletionIndicator(
          showCompleted: _showCompleted,
          completedRatio: cleared.length / originalPuzzles.length,
          onChanged: (bool? value) {
            if (value != null) {
              setState(() {
                _showCompleted = value;
              });
            }
          },
        )
      ],
    );
  }

  void _openPuzzle(int puzzleIndex) {
    if (puzzleIndex < originalPuzzles.length) {
      Router.of(context).routerDelegate.setNewRoutePath(
          NyaNyaRoutePath.originalPuzzle(originalPuzzles[puzzleIndex].slug));
    }
  }

  String _difficultyFromIndex(BuildContext context, int index) {
    if (index >= 0 && index < 25) {
      return NyaNyaLocalizations.of(context).easyLabel;
    } else if (index >= 25 && index < 50) {
      return NyaNyaLocalizations.of(context).intermediateLabel;
    } else if (index >= 50 && index < 75) {
      return NyaNyaLocalizations.of(context).hardLabel;
    } else if (index >= 75 && index < 100) {
      return NyaNyaLocalizations.of(context).veryHardLabel;
    } else {
      return 'Unspecified';
    }
  }

  Widget _buildPuzzleTile(int i, bool cleared, bool starred) {
    return ListTile(
      key: ValueKey(i),
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          '${i + 1}',
          style: const TextStyle(fontSize: 15),
          textAlign: TextAlign.center,
        ),
      ),
      title: Text(originalPuzzles[i].name),
      subtitle: Text(_difficultyFromIndex(context, i)),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        Visibility(
          visible: starred,
          child: Icon(
            Icons.star,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Visibility(
          visible: cleared,
          child: const Icon(
            Icons.check,
            color: Colors.green,
          ),
        ),
      ]),
      onTap: () {
        _openPuzzle(i);
      },
    );
  }

  Widget _buildPuzzleCard(int i, bool cleared) {
    return BoardCard(
        key: ValueKey(i),
        cleared: cleared,
        game: originalPuzzles[i].data.getGame(),
        description: [
          Text(
            originalPuzzles[i].name,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(_difficultyFromIndex(context, i))
        ],
        onTap: () {
          _openPuzzle(i);
        });
  }

  @override
  bool get wantKeepAlive => true;
}
