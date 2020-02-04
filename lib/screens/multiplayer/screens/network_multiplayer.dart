import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyanya_rocket/screens/multiplayer/network_client.dart';
import 'package:nyanya_rocket/screens/multiplayer/widgets/event_roulette.dart';
import 'package:nyanya_rocket/widgets/countdown.dart';
import 'package:nyanya_rocket/widgets/game_view/animated_game_view.dart';
import 'package:nyanya_rocket/widgets/input_grid_overlay.dart';
import 'package:nyanya_rocket/widgets/score_box.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class NetworkMultiplayer extends StatefulWidget {
  final String nickname;
  final InternetAddress serverAddress;

  const NetworkMultiplayer({Key key, this.nickname, this.serverAddress})
      : super(key: key);

  @override
  _NetworkMultiplayerState createState() => _NetworkMultiplayerState();
}

class _NetworkMultiplayerState extends State<NetworkMultiplayer>
    with SingleTickerProviderStateMixin<NetworkMultiplayer> {
  NetworkClient _localMultiplayerController;
  bool _displayRoulette = false;
  GameEvent _rouletteEvent = GameEvent.None;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _localMultiplayerController = NetworkClient(
        nickname: widget.nickname,
        serverAddress: widget.serverAddress,
        onGameEvent: _handleGameEvent);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]).catchError((Object error) {});

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _displayRoulette = false;
          });
        }
      });
  }

  @override
  void dispose() {
    super.dispose();

    _localMultiplayerController.close();

    SystemChrome.setPreferredOrientations([]).catchError((Object error) {});
  }

  void _handleSwipe(int x, int y, Direction direction) {
    _localMultiplayerController.placeArrow(x, y, direction);
  }

  void _handleGameEvent(GameEvent event) {
    _animationController.forward(from: 0);
    _rouletteEvent = event;
    setState(() {
      _displayRoulette = true;
    });
  }

  Widget _streamBuiltScoreBox(int i, Color color) => StreamBuilder<int>(
      stream: _localMultiplayerController.scoreStreams[i].stream,
      initialData: 0,
      builder: (context, snapshot) {
        return ScoreBox(
            label: _localMultiplayerController.players[i],
            score: snapshot.data,
            color: color);
      });

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
                        child: AspectRatio(
                            aspectRatio: 12.0 / 9.0,
                            child: InputGridOverlay<int>(
                              child: AnimatedGameView(
                                game: _localMultiplayerController.gameStream,
                              ),
                              onSwipe: _handleSwipe,
                            )),
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
              height: 200,
              child: EventRoulette(
                  animationController: _animationController,
                  finalEvent: _rouletteEvent),
            )),
          )
        ],
      ),
    );
  }
}
