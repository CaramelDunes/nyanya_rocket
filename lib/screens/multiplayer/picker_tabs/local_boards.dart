import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/widgets/layout/empty_list.dart';

import '../../../models/stores/multiplayer_store.dart';

class LocalBoards extends StatefulWidget {
  const LocalBoards({super.key});

  @override
  State<LocalBoards> createState() => _LocalBoardsState();
}

class _LocalBoardsState extends State<LocalBoards> {
  Map<String, String> _boards = {};

  @override
  void initState() {
    super.initState();

    MultiplayerStore.registry()
        .then((Map<String, String> entries) => setState(() {
              _boards = entries;
            }));
  }

  @override
  Widget build(BuildContext context) {
    List<String> uuidList = _boards.keys.toList().reversed.toList();

    if (uuidList.isEmpty) {
      return const Center(child: EmptyList());
    }

    return ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _boards.length,
        itemBuilder: (context, i) => ListTile(
              title: Text(_boards[uuidList[i]]!),
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
              ),
              onTap: () {
                MultiplayerStore.read(uuidList[i])
                    .then((MultiplayerBoard? board) {
                  // FIXME
                  Navigator.of(context).pop(board);
                });
              },
            ));
  }
}
