import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/multiplayer/network_client.dart';
import 'package:nyanya_rocket/screens/multiplayer/widgets/event_wheel.dart';
import 'package:nyanya_rocket/widgets/arrow_image.dart';
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
  PlayerColor _myColor;

  @override
  void initState() {
    super.initState();

    _localMultiplayerController = NetworkClient(
        nickname: widget.nickname,
        serverAddress: widget.serverAddress,
        port: widget.port,
        onGameEvent: _handleGameEvent,
        onRegisterSuccess: _handleRegisterSuccess,
        ticket: widget.ticket);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]).catchError((Object error) {});

    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    _localMultiplayerController.close();

    SystemChrome.setPreferredOrientations([]).catchError((Object error) {});

    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    super.dispose();
  }

  void _handleSwipe(int x, int y, Direction direction) {
    _localMultiplayerController.placeArrow(x, y, PlayerColor.Blue, direction);
  }

  void _handleRegisterSuccess(PlayerColor assignedColor) {
    setState(() {
      _myColor = assignedColor;
    });
  }

  void _handleGameEvent(GameEvent event) {
    // Not 0 to have a card above and under the starting position on the wheel.
    _scrollController.jumpToItem(1);

    if (event != GameEvent.None) {
      setState(() {
        _displayRoulette = true;
      });

      // The scroll controller won't animate if the wheel hasn't been attached
      // before.
      // Using a Wheel as a state attribute doesn't work because its build
      // function creates a new ScrollView every time.
      // Possible fixes:
      // - make Wheel inherit ScrollView directly.
      // - make Wheel keep its ScrollView across redraws.
      SchedulerBinding.instance.addPostFrameCallback((_) {
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
    return ValueListenableBuilder<int>(
        valueListenable: _localMultiplayerController.scoreStreams[i],
        builder: (context, score, _) {
          return ScoreBox(
              label: _localMultiplayerController.players[i],
              score: score,
              color: color);
        });
  }

  Widget _dragTileBuilder(BuildContext context, List<Direction> candidateData,
      List rejectedData, int x, int y) {
    if (candidateData.isEmpty) return const SizedBox.expand();

    return ArrowImage(
      direction: candidateData[0],
      player: _myColor,
      opaque: false,
    );
  }

  Widget _draggableArrow(PlayerColor player, Direction direction) {
    if (player == null) {
      return const SizedBox.expand();
    }

    return Material(
      elevation: 8.0,
      child: Draggable<Direction>(
          maxSimultaneousDrags: 1,
          feedback: const SizedBox.shrink(),
          child: ArrowImage(
            player: player,
            direction: direction,
          ),
          data: direction),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              ValueListenableBuilder<Duration>(
                  valueListenable: _localMultiplayerController.timeStream,
                  builder: (_, remaining, __) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Countdown(
                        remaining: remaining,
                      ),
                    );
                  }),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                                child: _streamBuiltScoreBox(0, Colors.blue)),
                            Expanded(
                                child: _streamBuiltScoreBox(1, Colors.yellow)),
                            Expanded(
                                child: _streamBuiltScoreBox(2, Colors.red)),
                            Expanded(
                                child: _streamBuiltScoreBox(3, Colors.green)),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      elevation: 8.0,
                      child: AspectRatio(
                          aspectRatio: 12.0 / 9.0,
                          child: InputGridOverlay<Direction>(
                            child: AnimatedGameView(
                              game: _localMultiplayerController.gameStream,
                            ),
                            onSwipe: _handleSwipe,
                            onDrop: _handleSwipe,
                            previewBuilder: _dragTileBuilder,
                          )),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: _draggableArrow(_myColor, Direction.Right),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: _draggableArrow(_myColor, Direction.Up),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: _draggableArrow(_myColor, Direction.Left),
                          )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: _draggableArrow(_myColor, Direction.Down),
                          )),
                        ],
                      ),
                    ),
                  ],
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
          ),
          Visibility(
              visible: _localMultiplayerController.status !=
                  NetworkGameStatus.Playing,
              child: _buildWaitingCard())
        ],
      ),
    );
  }

  String _networkGameStatusToString(NetworkGameStatus status) {
    switch (status) {
      case NetworkGameStatus.ConnectingToServer:
        return NyaNyaLocalizations.of(context).connectingToServerText;
        break;
      case NetworkGameStatus.WaitingForPlayers:
        return NyaNyaLocalizations.of(context).waitingForPlayersText;
        break;
      case NetworkGameStatus.Playing:
        return 'Playing...';
        break;
      case NetworkGameStatus.Ended:
        return 'Game Over';
        break;
    }

    return '';
  }

  Widget _buildWaitingCard() {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _networkGameStatusToString(_localMultiplayerController.status),
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
    );
  }
}
