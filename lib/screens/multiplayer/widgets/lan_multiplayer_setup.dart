import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:nyanya_rocket/screens/multiplayer/screens/network_multiplayer.dart';
import 'package:nyanya_rocket/screens/multiplayer/toy_server.dart';
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

  static Isolate isolate;
  final _formKey = GlobalKey<FormState>();

  Future<String> _ipFuture;

  @override
  void initState() {
    super.initState();

    _ipFuture = Connectivity().getWifiIP();
    _ipFuture.then((String ip) {
      if (mounted) {
        setState(() {
          _localIp = ip ?? '';
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  static void serverEntryPoint(int nbPlayer) {
    ToyServer(nbPlayer: nbPlayer, board: Board());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nickname'),
                  maxLength: 16,
                  textCapitalization: TextCapitalization.words,
                  onSaved: (String value) => _nickname = value,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid nickname.';
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Server hostname',
                  ),
                  onSaved: (String value) => _hostname = value,
                  validator: (String value) {
                    if (!LanMultiplayerSetup.hostnameMatcher.hasMatch(value)) {
                      return 'Please enter a valid hostname.';
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Text('Connect'),
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
                          if (_LanMultiplayerSetupState.isolate != null) {
                            _LanMultiplayerSetupState.isolate.kill();
                          }
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButton<int>(
                    value: _playerCount,
                    items: <DropdownMenuItem<int>>[
                      DropdownMenuItem(
                        child: Text('1 Players'),
                        value: 1,
                      ),
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
                  ),
                ),
              ),
            ],
          ),
          RaisedButton(
            child: Text('Create'),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () {
              if (_LanMultiplayerSetupState.isolate != null) {
                _LanMultiplayerSetupState.isolate.kill();
              }

              Isolate.spawn<int>(
                      _LanMultiplayerSetupState.serverEntryPoint, _playerCount)
                  .then((Isolate isolate) =>
                      _LanMultiplayerSetupState.isolate = isolate);
            },
          ),
        ],
      ),
    );
  }
}
