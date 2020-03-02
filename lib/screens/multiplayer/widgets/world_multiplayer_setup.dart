import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:nyanya_rocket/blocs/multiplayer_queue.dart';
import 'package:nyanya_rocket/models/user.dart';
import 'package:nyanya_rocket/screens/multiplayer/screens/network_multiplayer.dart';

class WorldMultiplayerSetup extends StatefulWidget {
  final User user;

  const WorldMultiplayerSetup({Key key, @required this.user}) : super(key: key);

  @override
  _WorldMultiplayerSetupState createState() => _WorldMultiplayerSetupState();
}

class _WorldMultiplayerSetupState extends State<WorldMultiplayerSetup> {
  static const Map<String, String> _masterServers = {
    'US East': 'nyanya-us-east.carameldunes.fr',
    'Europe West': 'nyanya-eu-west.carameldunes.fr'
  };

  String _selectedMasterIndex = 'US East';

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

    for (MultiplayerQueue queue in _queues.values) {
      queue.cancelSearch(
          authToken: _authToken,
          masterServerHostname: _masterServers[_selectedMasterIndex]);
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
              masterServerHostname: _masterServers[_selectedMasterIndex]);
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

    setState(() {
      _updatePending = true;
      _queues.values.forEach((MultiplayerQueue queue) {
        if (!queue.joined) {
          queue.length = null;
        }
      });
    });

    for (MultiplayerQueue queue in _queues.values) {
      try {
        await queue.queueLength(
            masterServerHostname: _masterServers[_selectedMasterIndex],
            authToken: _authToken);
      } catch (e) {
        print('Could not refresh queue size: $e');
      }
    }
    if (mounted) {
      setState(() {
        _updatePending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      queueName: 'Duel',
                      queue: _queues[QueueType.Duels],
                      updatePending: _updatePending,
                    )),
                    Expanded(
                        child: _buildQueueTile(
                      queueName: '4-player battle',
                      queue: _queues[QueueType.FourPlayers],
                      updatePending: _updatePending,
                    ))
                  ]);
            },
          ))
        ]);
  }

  Widget _buildRegionDropdown() {
    return Row(
      children: <Widget>[
        Text(
          'Region: ',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Expanded(
          child: DropdownButton(
              isExpanded: true,
              value: _selectedMasterIndex,
              onChanged: (key) {
                setState(() {
                  for (MultiplayerQueue queue in _queues.values) {
                    queue.cancelSearch(
                        authToken: _authToken,
                        masterServerHostname:
                            _masterServers[_selectedMasterIndex]);
                  }

                  _selectedMasterIndex = key;
                  _queues[QueueType.Duels].joined =
                      _queues[QueueType.FourPlayers].joined = false;
                });

                _updateQueueLength();
              },
              items: _masterServers.keys
                  .map((e) => DropdownMenuItem(
                        child: Text(e.toString()),
                        value: e,
                      ))
                  .toList()),
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            _updateQueueLength();
          },
        )
      ],
    );
  }

  Widget _buildQueueTile(
      {String queueName, bool updatePending, MultiplayerQueue queue}) {
    return Card(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  queue.joined
                      ? 'Position in the queue: ${queue.position} / ${queue.length}'
                      : (queue.length != null
                          ? '${queue.length} players in queue'
                          : updatePending
                              ? ''
                              : 'Error while refreshing queue info.'),
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(width: 16),
                if (updatePending || queue.joined) CircularProgressIndicator()
              ],
            )),
        RaisedButton(
          child: Text(queue.joined ? 'Cancel' : 'Join'),
          onPressed: () {
            setState(() {
              queue.joined = !queue.joined;
            });
          },
        ),
      ],
    ));
  }
}
