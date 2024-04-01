import 'package:flutter/material.dart';

import 'package:nyanya_rocket/screens/puzzles/community_puzzle_data.dart';
import '../../localization/nyanya_localizations.dart';
import 'puzzle.dart';

class LoadingPuzzle extends StatelessWidget {
  final Future<CommunityPuzzleData> futurePuzzle;

  const LoadingPuzzle({super.key, required this.futurePuzzle});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CommunityPuzzleData>(
        future: futurePuzzle,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Scaffold(
                appBar: AppBar(
                  title: Text(NyaNyaLocalizations.of(context).puzzlesTitle),
                ),
                body: Center(
                  child: Text(
                    NyaNyaLocalizations.of(context).loadingLabel,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              );

            case ConnectionState.active:
            case ConnectionState.done:
              if (!snapshot.hasError) {
                return Puzzle(
                  puzzle: snapshot.data!,
                  documentPath: 'puzzles/${snapshot.data!.uid}',
                );
              } else {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(NyaNyaLocalizations.of(context).puzzlesTitle),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          NyaNyaLocalizations.of(context)
                              .couldNotLoadPuzzleText,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        FilledButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(MaterialLocalizations.of(context)
                                .backButtonTooltip))
                      ],
                    ),
                  ),
                );
              }
          }
        });
  }
}
