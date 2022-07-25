import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../localization/nyanya_localizations.dart';
import '../../../models/multiplayer_board.dart';
import '../../../widgets/board/static_game_view.dart';
import '../screens/board_picker_lists.dart';

class BoardPicker extends StatefulWidget {
  final void Function(MultiplayerBoard value) onChanged;

  const BoardPicker({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<BoardPicker> createState() => _BoardPickerState();
}

class _BoardPickerState extends State<BoardPicker> {
  MultiplayerBoard? _selectedBoard;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _selectedBoard == null
                ? Text(NyaNyaLocalizations.of(context).boardSelectionText)
                : AspectRatio(
                    aspectRatio: 12 / 9,
                    child: StaticGameView(
                      game: GameState()..board = _selectedBoard!.board(),
                    ),
                  ),
          ),
        ),
        onTap: () {
          Navigator.push(
                  context,
                  MaterialPageRoute<MultiplayerBoard>(
                      builder: (context) => const BoardPickerLists()))
              .then((MultiplayerBoard? board) {
            if (board is MultiplayerBoard) {
              widget.onChanged(board);

              setState(() {
                _selectedBoard = board;
              });
            }
          });
        },
      ),
    );
  }
}
