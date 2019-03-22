import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/widgets/game_view/static_game_view.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class OriginalBoards extends StatelessWidget {
  static final List<MultiplayerBoard> boards = [
    MultiplayerBoard(
        name: 'Local Multiplayer',
        boardData:
            '{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4, "direction":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,2,0,0,0,0,0,1,2],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,2],[2,0,0,0,0,0,0,1,0]]}',
        maxPlayer: 2),
    MultiplayerBoard(
        name: 'Local Multiplayer',
        boardData:
            '{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4, "direction":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,2,0,0,0,0,0,1,2],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,2],[2,0,0,0,0,0,0,1,0]]}',
        maxPlayer: 2),
    MultiplayerBoard(
        name: 'Local Multiplayer',
        boardData:
            '{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4, "direction":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,2,0,0,0,0,0,1,2],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,2],[2,0,0,0,0,0,0,1,0]]}',
        maxPlayer: 2),
    MultiplayerBoard(
        name: 'Local Multiplayer',
        boardData:
            '{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4, "direction":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,2,0,0,0,0,0,1,2],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,2],[2,0,0,0,0,0,0,1,0]]}',
        maxPlayer: 2),
    MultiplayerBoard(
        name: 'Local Multiplayer',
        boardData:
            '{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4, "direction":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,2,0,0,0,0,0,1,2],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,2],[2,0,0,0,0,0,0,1,0]]}',
        maxPlayer: 2),
    MultiplayerBoard(
        name: 'Local Multiplayer',
        boardData:
            '{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4, "direction":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,2,0,0,0,0,0,1,2],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,2],[2,0,0,0,0,0,0,1,0]]}',
        maxPlayer: 2),
    MultiplayerBoard(
        name: 'Local Multiplayer',
        boardData:
            '{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4, "direction":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,2,0,0,0,0,0,1,2],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,2],[2,0,0,0,0,0,0,1,0]]}',
        maxPlayer: 2),
    MultiplayerBoard(
        name: 'Local Multiplayer',
        boardData:
            '{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4, "direction":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,2,0,0,0,0,0,1,2],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,2],[2,0,0,0,0,0,0,1,0]]}',
        maxPlayer: 2),
    MultiplayerBoard(
        name: 'Local Multiplayer',
        boardData:
            '{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4, "direction":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,2,0,0,0,0,0,1,2],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,2],[2,0,0,0,0,0,0,1,0]]}',
        maxPlayer: 2),
    MultiplayerBoard(
        name: 'Local Multiplayer',
        boardData:
            '{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4, "direction":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,2,0,0,0,0,0,1,2],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,2],[2,0,0,0,0,0,0,1,0]]}',
        maxPlayer: 2),
    MultiplayerBoard(
        name: 'Local Multiplayer',
        boardData:
            '{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4, "direction":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,2,0,0,0,0,0,1,2],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,2],[2,0,0,0,0,0,0,1,0]]}',
        maxPlayer: 2),
    MultiplayerBoard(
        name: 'Local Multiplayer',
        boardData:
            '{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4, "direction":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,2,0,0,0,0,0,1,2],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,2],[2,0,0,0,0,0,0,1,0]]}',
        maxPlayer: 2),
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
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          flex: 0,
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
                        Flexible(
                          child: Container(
                            child: Center(
                              child: Text(
                                OriginalBoards.boards[i].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        )
                      ],
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
