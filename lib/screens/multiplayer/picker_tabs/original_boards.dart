import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/widgets/game_view/static_game_view.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class OriginalBoards extends StatelessWidget {
  static final List<MultiplayerBoard> boards = [
    MultiplayerBoard(
        name: '1',
        boardData:
            '{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":3,"player":3},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":4,"direction":0},{"type":0},{"type":4,"direction":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":4,"direction":2},{"type":0},{"type":4,"direction":2},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":3,"player":1},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,3,1,1,1],[2,0,0,0,0,2,0,0,0],[2,0,0,0,0,2,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,0],[3,1,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,1,1],[2,0,0,0,0,0,0,0,0],[2,0,0,0,2,0,0,0,0],[2,0,0,0,2,0,0,0,0],[2,0,0,0,2,0,0,0,0]]}',
        maxPlayer: 4),
    MultiplayerBoard(
        name: '2',
        boardData:
            '{"tiles":[[{"type":4,"direction":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":3,"player":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":4,"direction":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":3,"player":2},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":4,"direction":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":3,"player":3},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":4,"direction":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":3,"player":1},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,3,1,3,1,3,1,3,1],[2,2,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,0],[2,2,0,0,0,0,0,0,0],[2,2,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,0],[2,2,0,0,0,0,0,0,0],[2,2,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,0],[2,2,0,0,0,0,0,0,0],[2,2,0,0,0,0,0,0,0],[2,0,2,0,2,0,2,0,0]]}',
        maxPlayer: 4),
    MultiplayerBoard(
        name: '3',
        boardData:
            '{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":4,"direction":1},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":3,"player":3},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4,"direction":2}],[{"type":4,"direction":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":3,"player":2},{"type":0},{"type":0},{"type":3,"player":1},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4,"direction":3},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,3,1,1,1,1],[2,0,0,0,0,0,1,0,0],[2,2,1,1,2,0,0,0,0],[2,0,0,0,2,0,0,2,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,2,0,0,2,0],[3,0,2,1,1,3,0,0,1],[2,0,0,0,0,0,0,0,0],[2,0,2,0,0,2,0,0,0],[2,0,0,0,0,2,0,0,2],[2,0,0,0,0,1,1,0,0],[2,0,1,0,0,2,0,0,0]]}',
        maxPlayer: 4),
    MultiplayerBoard(
        name: '4',
        boardData:
            '{"tiles":[[{"type":4,"direction":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4,"direction":1}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":3,"player":1},{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":3,"player":3},{"type":0},{"type":3,"player":2},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":4,"direction":3},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4,"direction":2}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,2,0,0,0,0,0,0,1],[2,0,2,0,0,0,0,1,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,2,0,1,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,2,0],[2,0,1,0,0,0,0,0,2],[2,1,0,0,0,0,0,0,0]]}',
        maxPlayer: 4),
  ];

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 3),
            itemCount: OriginalBoards.boards.length,
            itemBuilder: (context, i) => InkWell(
                  child: Card(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AspectRatio(
                          aspectRatio: 12 / 9,
                          child: StaticGameView(
                            game: Game()
                              ..board = OriginalBoards.boards[i].board(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(OriginalBoards.boards[i]);
                  },
                ));
      },
    );
  }
}
