import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:nyanya_rocket/blocs/queue_client.dart';
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

  final Map<QueueType, int> _queueSize = {
    QueueType.Duels: null,
    QueueType.FourPlayers: null
  };

  final Map<QueueType, int> _queuePosition = {
    QueueType.Duels: 0,
    QueueType.FourPlayers: 0
  };

  final Map<QueueType, bool> _joinedQueue = {
    QueueType.Duels: false,
    QueueType.FourPlayers: false
  };

  Timer _queueJoinUpdateTimer;

  String _authToken;

  @override
  void initState() {
    super.initState();

    widget.user.authToken().then((String token) {
      _authToken = token;
      _updateQueueSize();
    });

    _queueJoinUpdateTimer = Timer.periodic(Duration(seconds: 1), (_) {
      _updateQueueJoinStatus();
    });
  }

  @override
  void dispose() {
    _queueJoinUpdateTimer?.cancel();

    super.dispose();
  }

  Future _updateQueueJoinStatus() async {
    if (!widget.user.isConnected) {
      return;
    }

    for (QueueType queueType in _queueSize.keys) {
      if (_joinedQueue[queueType]) {
        QueueJoinStatus status = await QueueClient.updateQueueJoinStatus(
            authToken: _authToken,
            masterServerHostname: _masterServers[_selectedMasterIndex],
            queueType: queueType);

        if (status != null) {
          if (mounted) {
            if (status.position != null) {
              setState(() {
                _queuePosition[queueType] = status.position;
                _queueSize[queueType] = status.queueLength;
              });
            } else if (status.port != null) {
              _joinedQueue[QueueType.Duels] =
                  _joinedQueue[QueueType.FourPlayers] = false;

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

  Future _updateQueueSize() async {
    if (!widget.user.isConnected) {
      return;
    }

    setState(() {
      _updatePending = true;
      _joinedQueue.keys.forEach((QueueType queueType) {
        if (!_joinedQueue[queueType]) {
          _queueSize[queueType] = null;
        }
      });
    });

    for (QueueType queueType in _queueSize.keys) {
      _queueSize[queueType] = await QueueClient.queueSize(
          masterServerHostname: _masterServers[_selectedMasterIndex],
          queueType: queueType,
          authToken: _authToken);
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
                      queueType: QueueType.Duels,
                      updatePending: _updatePending,
                    )),
                    Expanded(
                        child: _buildQueueTile(
                      queueName: '4-player battle',
                      queueType: QueueType.FourPlayers,
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
                  _selectedMasterIndex = key;
                  _joinedQueue[QueueType.Duels] = false;
                  _joinedQueue[QueueType.FourPlayers] = false;
                });

                _updateQueueSize();
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
            _updateQueueSize();
          },
        )
      ],
    );
  }

  Widget _buildQueueTile(
      {String queueName,
      QueueType queueType,
      bool updatePending,
      QueueClient client}) {
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
                  _joinedQueue[queueType]
                      ? 'Position in the queue: ${_queuePosition[queueType]} / ${_queueSize[queueType]}'
                      : (_queueSize[queueType] != null
                          ? '${_queueSize[queueType]} players in queue'
                          : updatePending
                              ? ''
                              : 'Error while refreshing queue info.'),
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(width: 16),
                if (updatePending || _joinedQueue[queueType])
                  CircularProgressIndicator()
              ],
            )),
        RaisedButton(
          child: Text(_joinedQueue[queueType] ? 'Cancel' : 'Join'),
          onPressed: () {
            setState(() {
              _joinedQueue[queueType] = !_joinedQueue[queueType];
            });
          },
        ),
      ],
    ));
  }
}
