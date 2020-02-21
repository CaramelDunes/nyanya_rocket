import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyanya_rocket/screens/multiplayer/network_client.dart';
import 'package:nyanya_rocket/screens/multiplayer/widgets/event_wheel.dart';
import 'package:nyanya_rocket/widgets/countdown.dart';
import 'package:nyanya_rocket/widgets/game_view/animated_game_view.dart';
import 'package:nyanya_rocket/widgets/input_grid_overlay.dart';
import 'package:nyanya_rocket/widgets/score_box.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class NetworkMultiplayer extends StatefulWidget {
  final String nickname;
  final InternetAddress serverAddress;
  final int port;
  final int ticket;

  const NetworkMultiplayer(
      {Key key,
      @required this.nickname,
      @required this.serverAddress,
      @required this.port,
      this.ticket})
      : super(key: key);

  @override
  _NetworkMultiplayerState createState() => _NetworkMultiplayerState();
}

class _NetworkMultiplayerState extends State<NetworkMultiplayer> {
  NetworkClient _localMultiplayerController;
  bool _displayRoulette = false;
  FixedExtentScrollController _scrollController = FixedExtentScrollController();

  @override
  void initState() {
    super.initState();

    _localMultiplayerController = NetworkClient(
        nickname: widget.nickname,
        serverAddress: widget.serverAddress,
        port: widget.port,
        onGameEvent: _handleGameEvent,
        ticket: widget.ticket);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]).catchError((Object error) {});
  }

  @override
  void dispose() {
    _localMultiplayerController.close();

    SystemChrome.setPreferredOrientations([]).catchError((Object error) {});

    super.dispose();
  }

  void _handleSwipe(int x, int y, Direction direction) {
    _localMultiplayerController.placeArrow(x, y, direction);
  }

  void _handleGameEvent(GameEvent event) {
    // Not 0 to have a card above and under the starting position on the wheel.
    _scrollController.jumpToItem(1);

    if (event != GameEvent.None) {
      setState(() {
        _displayRoulette = true;
      });

      // The scroll controller won't animate if the wheel hasn't been attached
      // before. Wait for 32 milliseconds and hope it has been attached by then.
      // Using a Wheel as a state attribute doesn't work because its build
      // function creates a new ScrollView every time.
      // Possible fix: make Wheel inherit ScrollView directly.
      Timer(Duration(milliseconds: 32), () {
        _scrollController.animateToItem(
            // Not * 4 to have a card above and under on the wheel.
            (GameEvent.values.length - 1) * 3 + event.index - 1,
            duration: Duration(milliseconds: 1500),
            curve: Curves.decelerate);
      });

      Timer(Duration(seconds: 3), () {
        setState(() {
          _displayRoulette = false;
        });
      });
    }
  }

  Widget _streamBuiltScoreBox(int i, Color color) {
    return StreamBuilder<int>(
        stream: _localMultiplayerController.scoreStreams[i].stream,
        initialData: 0,
        builder: (context, snapshot) {
          return ScoreBox(
              label: _localMultiplayerController.players[i],
              score: snapshot.data,
              color: color);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Spacer(flex: 1),
                      Flexible(child: _streamBuiltScoreBox(0, Colors.blue)),
                      Spacer(flex: 2),
                      Flexible(child: _streamBuiltScoreBox(2, Colors.red)),
                    ],
                  ),
                ),
              ),
              Flexible(
                  flex: 4,
                  child: Column(
                    children: <Widget>[
                      StreamBuilder<Object>(
                          stream: _localMultiplayerController.timeStream.stream,
                          initialData: Duration.zero,
                          builder: (context, snapshot) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Countdown(
                                remaining: snapshot.data,
                              ),
                            );
                          }),
                      Flexible(
                        child: Material(
                          elevation: 8.0,
                          child: AspectRatio(
                              aspectRatio: 12.0 / 9.0,
                              child: InputGridOverlay<int>(
                                child: AnimatedGameView(
                                  game: _localMultiplayerController.gameStream,
                                ),
                                onSwipe: _handleSwipe,
                              )),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Spacer(flex: 1),
                      Flexible(child: _streamBuiltScoreBox(1, Colors.yellow)),
                      Spacer(flex: 2),
                      Flexible(child: _streamBuiltScoreBox(3, Colors.green)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: _displayRoulette,
            child: Center(
                child: Container(
              width: 450,
              height: 200,
              child: EventWheel(
                scrollController: _scrollController,
              ),
            )),
          )
        ],
      ),
    );
  }
}
