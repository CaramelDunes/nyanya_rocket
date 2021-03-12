import 'package:flutter/material.dart';

import 'package:nyanya_rocket/screens/puzzles/community_puzzle_data.dart';
import '../../localization/nyanya_localizations.dart';
import 'puzzle.dart';

class LoadingPuzzle extends StatelessWidget {
  final Future<CommunityPuzzleData> futurePuzzle;

  LoadingPuzzle({Key? key, required this.futurePuzzle}) : super(key: key);

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
                    style: Theme.of(context).textTheme.headline2,
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
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(NyaNyaLocalizations.of(context).back))
                      ],
                    ),
                  ),
                );
              }
          }
        });
  }
}
