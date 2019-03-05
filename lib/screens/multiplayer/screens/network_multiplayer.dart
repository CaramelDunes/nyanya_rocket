import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyanya_rocket/screens/multiplayer/network_client.dart';
import 'package:nyanya_rocket/widgets/countdown.dart';
import 'package:nyanya_rocket/widgets/input_grid_overlay.dart';
import 'package:nyanya_rocket/widgets/game_view/animated_game_view.dart';
import 'package:nyanya_rocket/widgets/score_box.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class NetworkMultiplayer extends StatefulWidget {
  final String nickname;
  final String hostname;

  const NetworkMultiplayer({Key key, this.nickname, this.hostname})
      : super(key: key);

  @override
  _NetworkMultiplayerState createState() => _NetworkMultiplayerState();
}

class _NetworkMultiplayerState extends State<NetworkMultiplayer> {
  NetworkClient _localMultiplayerController;

  @override
  void initState() {
    super.initState();

    _localMultiplayerController =
        NetworkClient(nickname: widget.nickname, serverHostname: widget.hostname);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]).catchError(() {});
  }

  @override
  void dispose() {
    super.dispose();

    _localMultiplayerController.close();

    SystemChrome.setPreferredOrientations([]).catchError(() {});
  }

  void _handleSwipe(int x, int y, Direction direction) {
    _localMultiplayerController.placeArrow(x, y, direction);
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
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        flex: 0,
                        child: StreamBuilder<Object>(
                            stream:
                                _localMultiplayerController.timeStream.stream,
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
                      ),
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
          )
        ],
      ),
    );
  }
}
