import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/game_view.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class Puzzle extends StatefulWidget {
  @override
  _PuzzleState createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  Game puzzleGame;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puzzle'),
      ),
      body: Center(
        child: GameView(null),
      ),
    );
  }
}
