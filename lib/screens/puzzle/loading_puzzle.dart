import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../localization/nyanya_localizations.dart';
import '../../models/named_puzzle_data.dart';
import '../../models/puzzle_data.dart';
import 'puzzle.dart';

class LoadingPuzzle extends StatelessWidget {
  final Future<NamedPuzzleData> futurePuzzle;

  factory LoadingPuzzle.fromPuzzleId(String puzzleId) {
    final futurePuzzle = FirebaseFirestore.instance
        .doc('/puzzles/$puzzleId')
        .get()
        .then((snapshot) => NamedPuzzleData.fromPuzzleData(
            name: snapshot.get('name'),
            puzzleData:
                PuzzleData.fromJson(jsonDecode(snapshot.get('puzzle_data')))));

    return LoadingPuzzle(futurePuzzle: futurePuzzle);
  }

  LoadingPuzzle({Key? key, required this.futurePuzzle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NamedPuzzleData>(
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
