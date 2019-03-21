import 'package:flutter/material.dart';

class Puzzle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Text("""
A Puzzle game is won when every mice has reached a rocket.
You have a restricted amount of arrows to achieve that goal.

Note that you cannot place or remove an arrow after pressing the play button; you'll need to reset the level first.

You'll lose if:
  • A cat enters a rocket before every mice is safe.
  • A mouse gets eaten by a cat.
  • A mouse falls into a black hole.

You'll be awarded a star if you complete a level without using all the available arrows.
"""),
      ],
    );
  }
}
