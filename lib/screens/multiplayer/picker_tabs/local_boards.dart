import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/models/multiplayer_store.dart';
import 'package:nyanya_rocket/widgets/empty_list.dart';

class LocalBoards extends StatefulWidget {
  static final MultiplayerStore store = MultiplayerStore();

  @override
  _LocalBoardsState createState() => _LocalBoardsState();
}

class _LocalBoardsState extends State<LocalBoards> {
  Map<String, String> _boards = Map();

  @override
  void initState() {
    super.initState();

    LocalBoards.store.readRegistry().then((Map entries) => setState(() {
          _boards = entries;
        }));
  }

  @override
  Widget build(BuildContext context) {
    List<String> uuidList = _boards.keys.toList().reversed.toList();

    if (uuidList.isEmpty) {
      return Center(child: EmptyList());
    }

    return ListView.separated(
        separatorBuilder: (context, int) => Divider(),
        itemCount: _boards.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(_boards[uuidList[i]]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
              ),
              onTap: () {
                LocalBoards.store.readBoard(uuidList[i]).then(
                    (MultiplayerBoard board) =>
                        Navigator.of(context).pop(board));
              },
            ));
  }
}
