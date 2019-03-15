import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/screens/multiplayer/screens/device_multiplayer.dart';

class DeviceMultiplayerSetup extends StatefulWidget {
  @override
  _DeviceMultiplayerSetupState createState() {
    return _DeviceMultiplayerSetupState();
  }
}

final MultiplayerBoard testData = MultiplayerBoard(
    name: 'Local Multiplayer',
    boardData:
        '{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4, "direction":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,2,0,0,0,0,0,1,2],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,3,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,2],[2,2,0,0,0,0,0,1,2],[2,1,0,0,0,0,0,0,2],[2,0,0,0,0,0,0,1,0]]}',
    maxPlayer: 2);

class _DeviceMultiplayerSetupState extends State<DeviceMultiplayerSetup> {
  int _playerCount = 2;
  List<String> _playerNames = List.filled(4, '');
  Duration _duration = Duration(minutes: 3);

  GlobalKey<FormState> _formState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(8), children: [
      Form(
          key: _formState,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonFormField<Duration>(
                          value: _duration,
                          items: <DropdownMenuItem<Duration>>[
                            DropdownMenuItem(
                              child: Text('2 minutes'),
                              value: Duration(minutes: 2),
                            ),
                            DropdownMenuItem(
                              child: Text('3 minutes'),
                              value: Duration(minutes: 3),
                            ),
                            DropdownMenuItem(
                              child: Text('4 minutes'),
                              value: Duration(minutes: 4),
                            ),
                            DropdownMenuItem(
                              child: Text('5 minutes'),
                              value: Duration(minutes: 5),
                            ),
                          ],
                          onChanged: (Duration value) => setState(() {
                                _duration = value;
                              }),
                          onSaved: (Duration value) => _duration = value,
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: _playerCount,
                          items: <DropdownMenuItem<int>>[
                            DropdownMenuItem(
                              child: Text('2 Players'),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text('3 Players'),
                              value: 3,
                            ),
                            DropdownMenuItem(
                              child: Text('4 Players'),
                              value: 4,
                            ),
                          ],
                          onChanged: (int value) => setState(() {
                                _playerCount = value;
                              }),
                          onSaved: (int value) => _playerCount = value,
                        ),
                      ),
                    ],
                  ),
                  Divider()
                ] +
                List.generate(_playerCount, (int i) {
                  return TextFormField(
                    decoration: InputDecoration(hintText: 'Player ${i + 1}'),
                    maxLength: 16,
                    textCapitalization: TextCapitalization.words,
                    onSaved: (String text) {
                      _playerNames[i] = text;
                    },
                  );
                }) +
                [
                  Flexible(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text('Play'),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DeviceMultiplayer(
                                  board: testData,
                                  players:
                                      _playerNames.sublist(0, _playerCount),
                                  duration: _duration,
                                )));
                      },
                    ),
                  )
                ],
          )),
    ]);
  }
}
