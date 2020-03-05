import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/screens/multiplayer/screens/local_duel.dart';
import 'package:nyanya_rocket/screens/multiplayer/widgets/board_picker.dart';

class LocalDuelSetup extends StatefulWidget {
  @override
  _LocalDuelSetupState createState() => _LocalDuelSetupState();
}

class _LocalDuelSetupState extends State<LocalDuelSetup> {
  GlobalKey<FormState> _formState = GlobalKey();
  List<String> _playerNames = ['', ''];
  List<FocusNode> _nicknameNodes = [FocusNode(), FocusNode()];

  Duration _duration = Duration(minutes: 3);
  MultiplayerBoard _board;

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(8.0), children: <Widget>[
      Form(
          key: _formState,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButtonFormField<Duration>(
                value: _duration,
                items: <DropdownMenuItem<Duration>>[
                  DropdownMenuItem(
                    child: Text(
                        NyaNyaLocalizations.of(context).minuteCountLabel(2)),
                    value: Duration(minutes: 2),
                  ),
                  DropdownMenuItem(
                    child: Text(
                        NyaNyaLocalizations.of(context).minuteCountLabel(3)),
                    value: Duration(minutes: 3),
                  ),
                  DropdownMenuItem(
                    child: Text(
                        NyaNyaLocalizations.of(context).minuteCountLabel(4)),
                    value: Duration(minutes: 4),
                  ),
                  DropdownMenuItem(
                    child: Text(
                        NyaNyaLocalizations.of(context).minuteCountLabel(5)),
                    value: Duration(minutes: 5),
                  ),
                ],
                onChanged: (Duration value) => setState(() {
                  _duration = value;
                }),
                onSaved: (Duration value) => _duration = value,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
              TextFormField(
                focusNode: _nicknameNodes[0],
                onFieldSubmitted: (_) {
                  _nicknameNodes[0].unfocus();
                  FocusScope.of(context).requestFocus(_nicknameNodes[1]);
                },
                decoration: InputDecoration(
                    hintText:
                        '${NyaNyaLocalizations.of(context).nicknameLabel} 1'),
                maxLength: 16,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onSaved: (String text) {
                  _playerNames[0] = text;
                },
              ),
              TextFormField(
                focusNode: _nicknameNodes[1],
                decoration: InputDecoration(
                    hintText:
                        '${NyaNyaLocalizations.of(context).nicknameLabel} 2'),
                maxLength: 16,
                textCapitalization: TextCapitalization.words,
                onSaved: (String text) {
                  _playerNames[1] = text;
                },
              ),
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
                              builder: (BuildContext context) => LocalDuel(
                                    board: _board,
                                    players: _playerNames,
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
