import 'dart:isolate';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/screens/multiplayer/screens/network_multiplayer.dart';
import 'package:nyanya_rocket/screens/multiplayer/widgets/board_picker.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class LanMultiplayerSetup extends StatefulWidget {
  static final RegExp hostnameMatcher = RegExp(
      r'^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$');

  LanMultiplayerSetup({Key key}) : super(key: key);

  @override
  _LanMultiplayerSetupState createState() {
    return _LanMultiplayerSetupState();
  }
}

class _LanMultiplayerSetupState extends State<LanMultiplayerSetup> {
  String _localIp = '';
  String _nickname = '';
  String _hostname = 'localhost';

  int _playerCount = 2;
  Duration _duration = Duration(minutes: 3);

  static Isolate _serverIsolate;
  final _formKey = GlobalKey<FormState>();

  MultiplayerBoard _board;

  @override
  void initState() {
    super.initState();

    Connectivity().getWifiIP().then((String ip) {
      if (mounted) {
        setState(() {
          _localIp = ip ?? '';
        });
      }
    });
  }

  static void serverEntryPoint(ArgumentBundle arguments) {
    GameServer(nbPlayer: arguments.playerCount, board: arguments.board);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: NyaNyaLocalizations.of(context).nicknameLabel),
                maxLength: 16,
                textCapitalization: TextCapitalization.words,
                onSaved: (String value) => _nickname = value,
                validator: (String value) {
                  if (value.isEmpty) {
                    return NyaNyaLocalizations.of(context).invalidNicknameText;
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: NyaNyaLocalizations.of(context).hostnameLabel,
                ),
                onSaved: (String value) => _hostname = value,
                validator: (String value) {
                  if (!LanMultiplayerSetup.hostnameMatcher.hasMatch(value)) {
                    return NyaNyaLocalizations.of(context).invalidHostnameText;
                  }

                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text(NyaNyaLocalizations.of(context).playLabel),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  NetworkMultiplayer(
                                    nickname: _nickname,
                                    hostname: _hostname,
                                  )))
                          .then((dynamic) {
                        _LanMultiplayerSetupState._serverIsolate?.kill();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Text(
          _localIp,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30),
        ),
        Divider(),
        Row(
          children: <Widget>[
            Expanded(
              child: DropdownButton<Duration>(
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
              ),
            ),
            VerticalDivider(),
            Expanded(
              child: DropdownButton<int>(
                value: _playerCount,
                items: <DropdownMenuItem<int>>[
                  DropdownMenuItem(
                    child: Text(
                        '1 ${NyaNyaLocalizations.of(context).playersLabel}'),
                    value: 1,
                  ),
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
              ),
            ),
          ],
        ),
        Container(
          height: 150,
          child: BoardPicker(
            onChanged: (MultiplayerBoard board) {
              setState(() {
                _board = board;
              });
            },
          ),
        ),
        Container(
          child: Center(
            child: RaisedButton(
              child: Text(NyaNyaLocalizations.of(context).createLabel),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: _board == null
                  ? null
                  : () {
                      _LanMultiplayerSetupState._serverIsolate?.kill();

                      Isolate.spawn<ArgumentBundle>(
                              _LanMultiplayerSetupState.serverEntryPoint,
                              ArgumentBundle(_board.board(), _playerCount))
                          .then((Isolate isolate) => _LanMultiplayerSetupState
                              ._serverIsolate = isolate);
                    },
            ),
          ),
        ),
      ],
    );
  }
}

class ArgumentBundle {
  final Board board;
  final int playerCount;

  ArgumentBundle(this.board, this.playerCount);
}
