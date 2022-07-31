import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../board/static_game_view.dart';

class BoardCard extends StatelessWidget {
  final GameState game;
  final List<Widget> description;
  final bool cleared;
  final VoidCallback? onTap;

  const BoardCard(
      {super.key,
      required this.game,
      required this.description,
      this.cleared = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AspectRatio(
                  aspectRatio: 12 / 9,
                  child: Stack(
                    children: [
                      StaticGameView(game: game),
                      Visibility(
                        visible: cleared,
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: const Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 120,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
            ...description
          ],
        ),
      ),
    );
  }
}
