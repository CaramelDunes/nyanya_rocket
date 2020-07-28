import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/blocs/authenticated_client.dart';
import 'package:nyanya_rocket/blocs/private_queue.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/user.dart';
import 'package:nyanya_rocket/screens/multiplayer/screens/network_multiplayer.dart';

class FriendDuel extends StatefulWidget {
  final User user;
  final String masterServerHostname;

  const FriendDuel(
      {Key key, @required this.user, @required this.masterServerHostname})
      : super(key: key);

  @override
  _FriendDuelState createState() => _FriendDuelState();
}

class _FriendDuelState extends State<FriendDuel> {
  AuthenticatedClient _client;
  PrivateQueue _queue;

  Timer _roomCreationUpdateTimer;
  bool inQueue = true;
  String _myRoomCode;
  String _destCode;
  bool gone = false;

  @override
  void initState() {
    super.initState();

    widget.user.authToken().then((String token) {
      _client = AuthenticatedClient(authToken: token);
      _queue = PrivateQueue(client: _client);
      _roomCreationUpdateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (inQueue) {
          _updateRoomCode();
        }
      });
    });
  }

  @override
  void dispose() {
    _roomCreationUpdateTimer?.cancel();

    _queue.cancelSearch(masterServerHostname: widget.masterServerHostname);

    _client?.close();

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
          Divider(),
          Expanded(flex: 3, child: _buildJoinPart()),
        ]);
  }

  Widget _buildLandscape() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _buildCodePart()),
          VerticalDivider(),
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
          if (inQueue && _myRoomCode != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(NyaNyaLocalizations.of(context).awaitingForPlayersLabel),
                CircularProgressIndicator(),
              ],
            )
          else if (!inQueue)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  inQueue = true;
                });
              },
            )
          else
            SizedBox.shrink()
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
            decoration: InputDecoration(hintText: 'Room Code'),
            textCapitalization: TextCapitalization.characters,
            maxLength: 4,
            expands: false,
            onChanged: (s) {
              _destCode = s;
            },
          ),
          RaisedButton(
            child: Text(NyaNyaLocalizations.of(context).playLabel),
            onPressed: () {
              _queue
                  .updateQueueJoinStatus(
                      masterServerHostname: widget.masterServerHostname,
                      roomCode: _destCode)
                  .then((value) {
                if (value.ticket != null && !gone) {
                  gone = true;

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => NetworkMultiplayer(
                          nickname: widget.user.displayName,
                          serverAddress: InternetAddress(value.ipAddress),
                          port: value.port,
                          ticket: value.ticket)));
                }
              });
            },
          )
        ],
      ),
    );
  }

  void _updateRoomCode() async {
    try {
      QueueJoinStatus status = await _queue.updateQueueCreateStatus(
          masterServerHostname: widget.masterServerHostname);

      if (status.roomId == null && !gone) {
        gone = true;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => NetworkMultiplayer(
                nickname: widget.user.displayName,
                serverAddress: InternetAddress(status.ipAddress),
                port: status.port,
                ticket: status.ticket)));
      } else {
        if (_myRoomCode != status.roomId) {
          setState(() {
            _myRoomCode = status.roomId;
          });
        }
      }
    } catch (e) {
      setState(() {
        inQueue = false;
        _myRoomCode = null;
      });
    }
  }

  Widget _codeBox() {
    if (inQueue && _myRoomCode == null)
      return CircularProgressIndicator();
    else if (_myRoomCode != null)
      return SelectableText(
        _myRoomCode,
        showCursor: true,
        style:
            Theme.of(context).textTheme.headline3.copyWith(color: Colors.black),
      );
    else
      return Text(NyaNyaLocalizations.of(context).playLabel);
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
}
