import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nyanya_rocket/blocs/multiplayer_queue.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/user.dart';
import 'package:nyanya_rocket/screens/multiplayer/screens/network_multiplayer.dart';
import '../../settings/region.dart';

class WorldMultiplayerSetup extends StatefulWidget {
  final User user;

  const WorldMultiplayerSetup({Key key, @required this.user}) : super(key: key);

  @override
  _WorldMultiplayerSetupState createState() => _WorldMultiplayerSetupState();
}

class _WorldMultiplayerSetupState extends State<WorldMultiplayerSetup>
    with AutomaticKeepAliveClientMixin<WorldMultiplayerSetup> {
  bool _updatePending = false;

  final Map<QueueType, MultiplayerQueue> _queues = {
    QueueType.Duels: MultiplayerQueue(type: QueueType.Duels),
    QueueType.FourPlayers: MultiplayerQueue(type: QueueType.FourPlayers)
  };

  Timer _queueJoinUpdateTimer;

  String _authToken;

  @override
  void initState() {
    super.initState();

    widget.user.authToken().then((String token) {
      _authToken = token;
      _updateQueueLength();
    });

    _queueJoinUpdateTimer = Timer.periodic(Duration(seconds: 1), (_) {
      _updateQueueJoinStatus();
    });
  }

  @override
  void dispose() {
    _queueJoinUpdateTimer?.cancel();

    if (widget.user.isConnected) {
      for (MultiplayerQueue queue in _queues.values) {
        queue.cancelSearch(
            authToken: _authToken,
            masterServerHostname: Provider.of<Region>(context, listen: false)
                .masterServerHostname);
      }
    }

    super.dispose();
  }

  Future _updateQueueJoinStatus() async {
    if (!widget.user.isConnected) {
      return;
    }

    for (MultiplayerQueue queue in _queues.values) {
      if (queue.joined) {
        QueueJoinStatus status;

        try {
          status = await queue.updateQueueJoinStatus(
              authToken: _authToken,
              masterServerHostname: Provider.of<Region>(context, listen: false)
                  .masterServerHostname);
        } catch (e) {
          print('Could not join queue: $e');
        }

        if (status != null) {
          if (mounted) {
            if (status.port == null) {
              setState(() {});
            } else {
              _queues[QueueType.Duels].joined =
                  _queues[QueueType.FourPlayers].joined = false;

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
  }

  Future _updateQueueLength() async {
    if (!widget.user.isConnected) {
      return;
    }

    _updatePending = true;
    _queues.values.forEach((MultiplayerQueue queue) {
      if (!queue.joined) {
        queue.length = null;
      }
    });

    if (mounted) {
      setState(() {});
    }

    for (MultiplayerQueue queue in _queues.values) {
      try {
        await queue.queueLength(
            masterServerHostname: Provider.of<Region>(context, listen: false)
                .masterServerHostname,
            authToken: _authToken);
      } catch (e) {
        print('Could not refresh queue size: $e');
      }
    }

    _updatePending = false;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_authToken == null) {
      return Center(
          child: Text(NyaNyaLocalizations.of(context).loginPromptText));
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildRegionDropdown()),
          Expanded(child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              return Flex(
                  direction: orientation == Orientation.portrait
                      ? Axis.vertical
                      : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                        child: _buildQueueTile(
                      queueName: NyaNyaLocalizations.of(context).duelLabel,
                      queue: _queues[QueueType.Duels],
                      updatePending: _updatePending,
                    )),
                    Expanded(
                        child: _buildQueueTile(
                      queueName:
                          NyaNyaLocalizations.of(context).fourPlayersLabel,
                      queue: _queues[QueueType.FourPlayers],
                      updatePending: _updatePending,
                    ))
                  ]);
            },
          ))
        ]);
  }

  Widget _buildRegionDropdown() {
    return IconButton(
      icon: Icon(Icons.refresh),
      onPressed: () {
        _updateQueueLength();
      },
    );
  }

  Widget _buildQueueTile(
      {String queueName, bool updatePending, MultiplayerQueue queue}) {
    return Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              queueName,
              style: TextStyle(fontSize: 25),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      queue.joined
                          ? NyaNyaLocalizations.of(context)
                              .positionInQueueText(queue.position, queue.length)
                          : (queue.length != null
                              ? NyaNyaLocalizations.of(context)
                                  .playersInQueueText(queue.length)
                              : updatePending
                                  ? ''
                                  : NyaNyaLocalizations.of(context)
                                      .queueRefreshErrorText),
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(width: 16),
                    if (updatePending || queue.joined)
                      CircularProgressIndicator()
                  ],
                )),
            RaisedButton(
              child: Text(queue.joined
                  ? NyaNyaLocalizations.of(context).cancel
                  : NyaNyaLocalizations.of(context).joinQueueLabel),
              onPressed: () {
                setState(() {
                  queue.joined = !queue.joined;
                });

                updateKeepAlive();
              },
            ),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => _queues.values.any((queue) => queue.joined);
}
