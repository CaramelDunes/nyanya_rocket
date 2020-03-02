import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/screens/multiplayer/screens/device_multiplayer.dart';
import 'package:nyanya_rocket/screens/multiplayer/widgets/board_picker.dart';

class DeviceMultiplayerSetup extends StatefulWidget {
  @override
  _DeviceMultiplayerSetupState createState() {
    return _DeviceMultiplayerSetupState();
  }
}

class _DeviceMultiplayerSetupState extends State<DeviceMultiplayerSetup> {
  int _playerCount = 2;
  List<String> _playerNames = List.filled(4, '');
  Duration _duration = Duration(minutes: 3);

  GlobalKey<FormState> _formState = GlobalKey();
  List<FocusNode> _nicknameNodes = List.generate(4, (_) => FocusNode());
  MultiplayerBoard _board;

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(8), children: <Widget>[
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
                      VerticalDivider(),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: _playerCount,
                          items: <DropdownMenuItem<int>>[
                            DropdownMenuItem(
                              child: Text(
                                  '2 ${NyaNyaLocalizations.of(context).playersLabel}'),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text(
                                  '3 ${NyaNyaLocalizations.of(context).playersLabel}'),
                              value: 3,
                            ),
                            DropdownMenuItem(
                              child: Text(
                                  '4 ${NyaNyaLocalizations.of(context).playersLabel}'),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      height: 150,
                      child: BoardPicker(
                        onChanged: (MultiplayerBoard board) {
                          setState(() {
                            _board = board;
                          });
                        },
                      ),
                    ),
                  ),
                ] +
                List.generate(_playerCount, (int i) {
                  return TextFormField(
                    focusNode: _nicknameNodes[i],
                    onFieldSubmitted: (i < _playerCount)
                        ? (_) {
                            _nicknameNodes[i].unfocus();
                            FocusScope.of(context)
                                .requestFocus(_nicknameNodes[i + 1]);
                          }
                        : null,
                    decoration: InputDecoration(
                        hintText:
                            '${NyaNyaLocalizations.of(context).nicknameLabel} ${i + 1}'),
                    maxLength: 16,
                    textCapitalization: TextCapitalization.words,
                    textInputAction:
                        (i < _playerCount) ? TextInputAction.next : null,
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
                      child: Text(NyaNyaLocalizations.of(context).playLabel),
                      onPressed: _board == null
                          ? null
                          : () {
                              _formState.currentState.save();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DeviceMultiplayer(
                                        board: _board,
                                        players: _playerNames.sublist(
                                            0, _playerCount),
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
