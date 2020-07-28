import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/blocs/authenticated_client.dart';
import 'package:nyanya_rocket/blocs/multiplayer_queue.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/user.dart';
import 'package:nyanya_rocket/screens/multiplayer/screens/network_multiplayer.dart';
import 'package:nyanya_rocket/screens/settings/region.dart';
import 'package:provider/provider.dart';

class PlayerFinder extends StatefulWidget {
  final QueueType queueType;
  final User user;
  final String authToken;

  const PlayerFinder(
      {Key key,
      @required this.queueType,
      @required this.user,
      @required this.authToken})
      : super(key: key);

  @override
  _PlayerFinderState createState() => _PlayerFinderState();
}

class _PlayerFinderState extends State<PlayerFinder> {
  bool _updatePending = false;

  MultiplayerQueue _queue;
  String _masterServerHostname;

  Timer _queueJoinUpdateTimer;

  AuthenticatedClient _client;

  @override
  void initState() {
    super.initState();

    _client = AuthenticatedClient(authToken: widget.authToken);

    _masterServerHostname =
        Provider.of<Region>(context, listen: false).masterServerHostname;

    _queue = MultiplayerQueue(type: widget.queueType, client: _client);
    _updateQueueLength();

    _queueJoinUpdateTimer = Timer.periodic(Duration(seconds: 1), (_) {
      _updateQueueJoinStatus();
    });
  }

  @override
  void dispose() {
    _queueJoinUpdateTimer?.cancel();

    if (widget.user.isConnected) {
      _queue.cancelSearch(masterServerHostname: _masterServerHostname);
    }

    _client.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FaIcon(FontAwesomeIcons.search),
            SizedBox(width: 8.0),
            Text(
              'Find a player',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                _queue.joined
                    ? NyaNyaLocalizations.of(context)
                        .positionInQueueText(_queue.position, _queue.length)
                    : (_queue.length != null
                        ? NyaNyaLocalizations.of(context)
                            .playersInQueueText(_queue.length)
                        : _updatePending
                            ? ''
                            : NyaNyaLocalizations.of(context)
                                .queueRefreshErrorText),
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            if (_updatePending || _queue.joined) CircularProgressIndicator(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              child: Text(_queue.joined
                  ? NyaNyaLocalizations.of(context).cancel
                  : NyaNyaLocalizations.of(context).joinQueueLabel),
              onPressed: () {
                setState(() {
                  _queue.joined = !_queue.joined;
                });

//            updateKeepAlive();
              },
            ),
            RaisedButton(
              child: Text('Refresh'),
              onPressed: () {
                _updateQueueLength();
              },
            )
          ],
        )
      ],
    );
  }

  Future _updateQueueJoinStatus() async {
    if (!widget.user.isConnected) {
      return;
    }

    if (_queue.joined) {
      QueueJoinStatus status;

      try {
        status = await _queue.updateQueueJoinStatus(
            masterServerHostname: _masterServerHostname);
      } catch (e) {
        print('Could not join queue: $e');
      }

      if (status != null) {
        if (mounted) {
          if (status.port == null) {
            setState(() {});
          } else {
            _queue.joined = false;

            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => NetworkMultiplayer(
                    nickname: widget.user.displayName,
                    serverAddress: InternetAddress(status.ipAddress),
                    port: status.port,
                    ticket: status.ticket)));
          }
        }
      } else {
        print('Error on queue info refresh.');
      }
    }
  }

  Future _updateQueueLength() async {
    if (!widget.user.isConnected) {
      return;
    }

    _updatePending = true;
    if (!_queue.joined) {
      _queue.length = null;
    }

    if (mounted) {
      setState(() {});
    }

    try {
      await _queue.queueLength(masterServerHostname: _masterServerHostname);
    } catch (e) {
      print('Could not refresh queue size: $e');
    }

    _updatePending = false;

    if (mounted) {
      setState(() {});
    }
  }
}
