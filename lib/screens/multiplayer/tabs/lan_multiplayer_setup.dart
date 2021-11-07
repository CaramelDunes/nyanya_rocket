import 'dart:io';
import 'dart:isolate';

import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/screens/multiplayer/screens/network_multiplayer.dart';
import 'package:nyanya_rocket/screens/multiplayer/setup_widgets/board_picker.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class LanMultiplayerSetup extends StatefulWidget {
  static final RegExp hostnameMatcher = RegExp(
      r'^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$');

  const LanMultiplayerSetup({Key? key}) : super(key: key);

  @override
  _LanMultiplayerSetupState createState() => _LanMultiplayerSetupState();
}

class _LanMultiplayerSetupState extends State<LanMultiplayerSetup> {
  String _localIpText = '';
  String _nickname = '';
  String _hostname = '10.0.2.2';

  int _playerCount = 2;
  Duration _duration = const Duration(minutes: 3);

  static Isolate? _serverIsolate;
  final _formKey = GlobalKey<FormState>();

  MultiplayerBoard? _board;

  final FocusNode _nicknameFocusNode = FocusNode();
  final FocusNode _hostnameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WifiInfo().getWifiIP().then((String? ip) {
      if (mounted) {
        setState(() {
          if (ip != null) {
            _localIpText = NyaNyaLocalizations.of(context).thisDeviceIpText(ip);
          }
        });
      }
    });
  }

  static void serverEntryPoint(_ArgumentBundle arguments) {
    GameServer(
        playerCount: arguments.playerCount,
        gameDuration: const Duration(minutes: 3),
        board: arguments.board,
        port: 43122);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LAN Multiplayer'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  focusNode: _nicknameFocusNode,
                  decoration: InputDecoration(
                      labelText: NyaNyaLocalizations.of(context).nicknameLabel),
                  maxLength: 16,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  onSaved: (String? value) => _nickname = value ?? _nickname,
                  onFieldSubmitted: (term) {
                    _nicknameFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_hostnameFocusNode);
                  },
                  validator: (String? value) {
                    if (value != null && value.isEmpty) {
                      return NyaNyaLocalizations.of(context)
                          .invalidNicknameText;
                    }

                    return null;
                  },
                ),
                TextFormField(
                  focusNode: _hostnameFocusNode,
                  initialValue: _hostname,
                  decoration: InputDecoration(
                    labelText: NyaNyaLocalizations.of(context).hostnameLabel,
                  ),
                  onSaved: (String? value) => _hostname = value ?? _hostname,
                  validator: (String? value) {
                    if (value == null ||
                        !LanMultiplayerSetup.hostnameMatcher.hasMatch(value)) {
                      return NyaNyaLocalizations.of(context)
                          .invalidHostnameText;
                    }

                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text(NyaNyaLocalizations.of(context).playLabel),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        InternetAddress.lookup(_hostname,
                                type: InternetAddressType.IPv4)
                            .then((List<InternetAddress> result) {
                          if (result.isNotEmpty) {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        NetworkMultiplayer(
                                            nickname: _nickname,
                                            serverAddress: result[0],
                                            port: 43122)))
                                .then((dynamic) {
                              _LanMultiplayerSetupState._serverIsolate?.kill();
                            });
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
            _localIpText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 25),
          ),
          const Divider(),
          Row(
            children: <Widget>[
              Expanded(
                child: DropdownButton<Duration>(
                  value: _duration,
                  items: <DropdownMenuItem<Duration>>[
                    DropdownMenuItem(
                      child: Text(
                          NyaNyaLocalizations.of(context).minuteCountLabel(2)),
                      value: const Duration(minutes: 2),
                    ),
                    DropdownMenuItem(
                      child: Text(
                          NyaNyaLocalizations.of(context).minuteCountLabel(3)),
                      value: const Duration(minutes: 3),
                    ),
                    DropdownMenuItem(
                      child: Text(
                          NyaNyaLocalizations.of(context).minuteCountLabel(4)),
                      value: const Duration(minutes: 4),
                    ),
                    DropdownMenuItem(
                      child: Text(
                          NyaNyaLocalizations.of(context).minuteCountLabel(5)),
                      value: const Duration(minutes: 5),
                    ),
                  ],
                  onChanged: (Duration? value) => setState(() {
                    _duration = value ?? _duration;
                  }),
                ),
              ),
              const VerticalDivider(),
              Expanded(
                child: DropdownButton<int>(
                  value: _playerCount,
                  items: <DropdownMenuItem<int>>[
                    DropdownMenuItem(
                      child: Text(
                          NyaNyaLocalizations.of(context).playerCountLabel(1)),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text(
                          NyaNyaLocalizations.of(context).playerCountLabel(2)),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: Text(
                          NyaNyaLocalizations.of(context).playerCountLabel(3)),
                      value: 3,
                    ),
                    DropdownMenuItem(
                      child: Text(
                          NyaNyaLocalizations.of(context).playerCountLabel(4)),
                      value: 4,
                    ),
                  ],
                  onChanged: (int? value) => setState(() {
                    _playerCount = value ?? _playerCount;
                  }),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 150,
            child: BoardPicker(
              onChanged: (MultiplayerBoard board) {
                setState(() {
                  _board = board;
                });
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: Text(NyaNyaLocalizations.of(context).createLabel),
              onPressed: _board == null
                  ? null
                  : () {
                      _LanMultiplayerSetupState._serverIsolate?.kill();

                      Isolate.spawn<_ArgumentBundle>(
                              _LanMultiplayerSetupState.serverEntryPoint,
                              _ArgumentBundle(_board!.board(), _playerCount))
                          .then((Isolate isolate) => _LanMultiplayerSetupState
                              ._serverIsolate = isolate);

                      _hostname = '10.0.2.2';
                    },
            ),
          ),
        ],
      ),
    );
  }
}

class _ArgumentBundle {
  final Board board;
  final int playerCount;

  _ArgumentBundle(this.board, this.playerCount);
}
