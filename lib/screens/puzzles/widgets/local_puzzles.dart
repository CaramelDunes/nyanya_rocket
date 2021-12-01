import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/named_puzzle_data.dart';
import 'package:nyanya_rocket/models/user.dart';
import 'package:nyanya_rocket/screens/puzzle/puzzle.dart';
import 'package:nyanya_rocket/widgets/board_list.dart';
import 'package:nyanya_rocket/widgets/empty_list.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../config.dart';
import '../../../models/stores/puzzle_store.dart';
import '../../../widgets/game_view/static_game_view.dart';

class LocalPuzzles extends StatelessWidget {
  const LocalPuzzles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: PuzzleStore.registry(),
        builder: (context, AsyncSnapshot<Map<String, String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final Map<String, String> puzzles = snapshot.data!;

          final List<String> uuidList = puzzles.keys.toList().reversed.toList();
          if (uuidList.isEmpty) {
            return const Center(child: EmptyList());
          }

          return Consumer<User>(builder: (context, User user, _) {
            return BoardList(
                itemCount: uuidList.length,
                tileBuilder: (context, i) => _buildPuzzleTile(
                    context, uuidList[i], puzzles[uuidList[i]]!, user),
                cardBuilder: (context, i) => _buildPuzzleCard(
                    context, uuidList[i], puzzles[uuidList[i]]!, user));
          });
        });
  }

  Widget _buildPuzzleTile(
      BuildContext context, String uuid, String name, User user) {
    return ListTile(
      title: Text(name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
//                  IconButton(
//                    icon: Icon(Icons.share),
//                    onPressed: () {
//                      Share.share(
//                          'Check out this new puzzle I made! nyanya://puzzle/superjsonbase64');
//                    },
//                  ),
          IconButton(
            icon: const Icon(Icons.publish),
            tooltip: NyaNyaLocalizations.of(context).publishLabel,
            onPressed: () {
              _handlePublishTapped(context, uuid, user);
            },
          ),
        ],
      ),
      onTap: () {
        _openPuzzle(context, uuid);
      },
    );
  }

  Widget _buildPuzzleCard(
      BuildContext context, String uuid, String name, User user) {
    return InkWell(
      key: ValueKey(uuid),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AspectRatio(
                  aspectRatio: 12 / 9,
                  child: FutureBuilder(
                    future: PuzzleStore.read(uuid),
                    builder: (BuildContext context,
                        AsyncSnapshot<NamedPuzzleData?> snapshot) {
                      if (snapshot.hasData) {
                        return StaticGameView(
                            game: snapshot.data!.data.getGame());
                      } else {
                        return const Text('Loading...');
                      }
                    },
                  ),
                )),
            Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.publish),
                      tooltip: NyaNyaLocalizations.of(context).publishLabel,
                      onPressed: () {
                        _handlePublishTapped(context, uuid, user);
                      },
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        _openPuzzle(context, uuid);
      },
    );
  }

  void _verifyAndPublish(BuildContext context, NamedPuzzleData puzzle) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Puzzle(
                  puzzle: puzzle,
                  onWin: (_) {
                    context
                        .read<User>()
                        .idToken()
                        .then((idToken) => http.post(
                            Uri.https(kCloudFunctionsHost, '/publishPuzzle'),
                            headers: {
                              'Authorization': 'Bearer $idToken',
                              'Content-Type': 'application/json'
                            },
                            body: jsonEncode({
                              'data': {
                                'name': puzzle.name,
                                'puzzle_data': jsonEncode(puzzle.data.toJson()),
                              }
                            })))
                        .then((response) => response.statusCode == 200)
                        .then((success) {
                      if (success) {
                        final snackBar = SnackBar(
                            content: Text(NyaNyaLocalizations.of(context)
                                .publishSuccessText));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    });
                    // else {
                    //   final snackBar = SnackBar(
                    //       content: Text(
                    //           NyaNyaLocalizations.of(context).puzzleNotCompletedLocallyText));
                    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // }
                  },
                )));
  }

  void _openPuzzle(BuildContext context, String uuid) {
    PuzzleStore.read(uuid).then((NamedPuzzleData? puzzle) {
      if (puzzle != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Puzzle(
                  puzzle: puzzle,
                  // hasNext: i != uuidList.length - 1, TODO
                )));
      }
    });
  }

  void _handlePublishTapped(BuildContext context, String uuid, User user) {
    if (user.isConnected) {
      PuzzleStore.read(uuid).then((NamedPuzzleData? puzzle) {
        if (puzzle != null) {
          _verifyAndPublish(context, puzzle);
        }
      });
    } else {
      final snackBar = SnackBar(
          content: Text(NyaNyaLocalizations.of(context).loginPromptText));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
