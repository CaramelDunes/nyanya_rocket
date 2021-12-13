import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/blocs/authenticated_client.dart';
import 'package:nyanya_rocket/blocs/multiplayer_queue.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/multiplayer/screens/network_multiplayer.dart';

class PlayerFinder extends StatefulWidget {
  final QueueType queueType;
  final String displayName;
  final String idToken;
  final String masterServerHostname;

  const PlayerFinder(
      {Key? key,
      required this.queueType,
      required this.displayName,
      required this.idToken,
      required this.masterServerHostname})
      : super(key: key);

  @override
  _PlayerFinderState createState() => _PlayerFinderState();
}

class _PlayerFinderState extends State<PlayerFinder> {
  bool _updatePending = false;

  late MultiplayerQueue _queue;

  late Timer _queueJoinUpdateTimer;

  late AuthenticatedClient _client;

  @override
  void initState() {
    super.initState();

    _client = AuthenticatedClient(authToken: widget.idToken);

    _queue = MultiplayerQueue(
        type: widget.queueType,
        client: _client,
        masterServerHostname: widget.masterServerHostname);
    _updateQueueLength();

    _queueJoinUpdateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateQueueJoinStatus();
    });
  }

  @override
  void dispose() {
    _queueJoinUpdateTimer.cancel();

    _queue.cancelSearch();

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
            const FaIcon(FontAwesomeIcons.search),
            const SizedBox(width: 8.0),
            Text(
              NyaNyaLocalizations.of(context).findPlayersLabel,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                _queue.joined
                    ? NyaNyaLocalizations.of(context).positionInQueueText(
                        _queue.position,
                        _queue.length ?? 0) // FIXME length==0 after joining
                    : (_queue.length != null
                        ? NyaNyaLocalizations.of(context)
                            .playersInQueueText(_queue.length ?? 0)
                        : _updatePending
                            ? ''
                            : NyaNyaLocalizations.of(context)
                                .queueRefreshErrorText),
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            if (_updatePending || _queue.joined)
              const CircularProgressIndicator(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text(_queue.joined
                  ? NyaNyaLocalizations.of(context).cancel
                  : NyaNyaLocalizations.of(context).joinQueueLabel),
              onPressed: () {
                setState(() {
                  _queue.joined = !_queue.joined;
                });
              },
            ),
            ElevatedButton(
              child: Text(NyaNyaLocalizations.of(context).refreshLabel),
              onPressed: () {
                _updateQueueLength();
              },
            )
          ],
        )
      ],
    );
  }

  Future<void> _updateQueueJoinStatus() async {
    if (_queue.joined) {
      QueueJoinStatus status;

      try {
        status = await _queue.updateQueueJoinStatus();

        if (mounted) {
          // FIXME
          if (status.port == null) {
            setState(() {});
          } else {
            _queue.joined = false;

            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => NetworkMultiplayer(
                    nickname: widget.displayName,
                    serverAddress: InternetAddress(status.ipAddress!),
                    port: status.port!,
                    ticket: status.ticket)));
          }
        }
      } catch (e) {
        print('Could not join queue: $e');
      }
    }
  }

  Future<void> _updateQueueLength() async {
    _updatePending = true;
    if (!_queue.joined) {
      _queue.length = null;
    }

    if (mounted) {
      setState(() {});
    }

    try {
      await _queue.queueLength();
    } catch (e) {
      print('Could not refresh queue size: $e');
    }

    _updatePending = false;

    if (mounted) {
      setState(() {});
    }
  }
}
