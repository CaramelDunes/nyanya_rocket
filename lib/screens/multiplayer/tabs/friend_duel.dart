import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/blocs/authenticated_client.dart';
import 'package:nyanya_rocket/blocs/private_queue.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/multiplayer/screens/network_multiplayer.dart';

class FriendDuel extends StatefulWidget {
  final String idToken;
  final String displayName;
  final String masterServerHostname;

  const FriendDuel(
      {Key? key,
      required this.displayName,
      required this.idToken,
      required this.masterServerHostname})
      : super(key: key);

  @override
  State<FriendDuel> createState() => _FriendDuelState();
}

class _FriendDuelState extends State<FriendDuel> {
  late AuthenticatedClient _client;
  late PrivateQueue _queue;

  late Timer _roomCreationUpdateTimer;
  bool _inQueue = true;
  String? _myRoomCode;
  String? _destCode;
  bool _isInGame = false;

  @override
  void initState() {
    super.initState();

    _client = AuthenticatedClient(authToken: widget.idToken);
    _queue = PrivateQueue(client: _client);
    _roomCreationUpdateTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_inQueue) {
        _updateRoomCode();
      }
    });
  }

  @override
  void dispose() {
    _roomCreationUpdateTimer.cancel();

    _queue.cancelSearch(masterServerHostname: widget.masterServerHostname);

    _client.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            if (orientation == Orientation.portrait) {
              return _buildPortrait();
            } else {
              return _buildLandscape();
            }
          },
        ));
  }

  Widget _buildPortrait() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 2, child: _buildCodePart()),
          const Divider(),
          Expanded(flex: 3, child: _buildJoinPart()),
        ]);
  }

  Widget _buildLandscape() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _buildCodePart()),
          const VerticalDivider(),
          Expanded(child: _buildJoinPart()),
        ]);
  }

  Widget _buildCodePart() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            NyaNyaLocalizations.of(context).yourRoomCodeLabel,
            style: Theme.of(context).textTheme.headline6,
          ),
          _buildRoomCode(),
          if (_inQueue && _myRoomCode != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(NyaNyaLocalizations.of(context).awaitingForPlayersLabel),
                const CircularProgressIndicator(),
              ],
            )
          else if (!_inQueue)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _inQueue = true;
                });
              },
            )
          else
            const SizedBox.shrink()
        ],
      ),
    );
  }

  Widget _buildJoinPart() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            NyaNyaLocalizations.of(context).joinRoomLabel,
            style: Theme.of(context).textTheme.headline6,
          ),
          TextField(
            decoration: InputDecoration(
                hintText: NyaNyaLocalizations.of(context).roomCodeLabel),
            textCapitalization: TextCapitalization.characters,
            maxLength: 4,
            expands: false,
            onChanged: (s) {
              setState(() {
                _destCode = s;
              });
            },
          ),
          ElevatedButton(
            onPressed: _destCode != null
                ? () {
                    _queue
                        .updateQueueJoinStatus(
                            masterServerHostname: widget.masterServerHostname,
                            roomCode: _destCode!.toUpperCase())
                        .then((status) {
                      if (status.ticket != null) {
                        _startIfNotInGame(
                            InternetAddress(status.ipAddress!), // FIXME
                            status.port!,
                            status.ticket!);
                      }
                    });
                  }
                : null,
            child: Text(NyaNyaLocalizations.of(context).playLabel),
          )
        ],
      ),
    );
  }

  void _updateRoomCode() async {
    try {
      QueueJoinStatus status = await _queue.updateQueueCreateStatus(
          masterServerHostname: widget.masterServerHostname);

      if (status.roomId == null) {
        _startIfNotInGame(
            InternetAddress(status.ipAddress!), status.port!, status.ticket!);
      } else {
        if (mounted && _myRoomCode != status.roomId) {
          setState(() {
            _myRoomCode = status.roomId;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _inQueue = false;
          _myRoomCode = null;
        });
      }
    }
  }

  Widget _codeBox() {
    if (_inQueue && _myRoomCode == null) {
      return const CircularProgressIndicator();
    } else if (_myRoomCode != null) {
      return SelectableText(
        _myRoomCode!,
        showCursor: true,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 50),
      );
    } else {
      return Text(NyaNyaLocalizations.of(context).roomCodeRetrievalErrorText);
    }
  }

  Widget _buildRoomCode() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.grey.withAlpha(128),
            borderRadius: BorderRadius.circular(5.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _codeBox(),
        ));
  }

  void _startIfNotInGame(
      InternetAddress internetAddress, int port, int ticket) {
    if (!_isInGame) {
      _isInGame = true;
      _roomCreationUpdateTimer.cancel();

      Navigator.of(context)
          .push(MaterialPageRoute(
              maintainState: false,
              builder: (BuildContext context) => NetworkMultiplayer(
                  nickname: widget.displayName,
                  serverAddress: internetAddress,
                  port: port,
                  ticket: ticket)))
          .then((value) {
        _isInGame = false;
      });
    }
  }
}
