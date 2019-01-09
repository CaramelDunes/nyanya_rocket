import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/game_view/game_view.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Game g = Game();

    g.board.tiles[1][1] = Pit();
    g.board.tiles[2][2] = Rocket(PlayerColor.Green);
    g.board.tiles[3][3] = Arrow(PlayerColor.Blue, Direction.Right);
    g.board.tiles[4][4] = Arrow(PlayerColor.Green, Direction.Right);
    g.board.tiles[5][5] = Arrow(PlayerColor.Red, Direction.Down);
    g.board.tiles[6][6] = Generator(Direction.Down);

    g.entities[1] = Cat(EntityMovement.centered(5, 6, Direction.Right));

    return Scaffold(
      appBar: AppBar(
        title: Text('NyaNya Rocket !'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
              child: AspectRatio(aspectRatio: 12.0 / 9.0, child: GameView(g))),
        ],
      ),
    );
  }
}
