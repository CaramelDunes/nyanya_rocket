import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/screens/multiplayer/device_multiplayer_game_controller.dart';
import 'package:nyanya_rocket/screens/multiplayer/widgets/event_wheel.dart';
import 'package:nyanya_rocket/widgets/arrow_image.dart';
import 'package:nyanya_rocket/widgets/countdown.dart';
import 'package:nyanya_rocket/widgets/game_view/animated_game_view.dart';
import 'package:nyanya_rocket/widgets/input_grid_overlay.dart';
import 'package:nyanya_rocket/widgets/score_box.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class DeviceMultiplayer extends StatefulWidget {
  final MultiplayerBoard board;
  final List<String> players;
  final Duration duration;

  DeviceMultiplayer(
      {@required this.board, @required this.players, @required this.duration});

  @override
  _DeviceMultiplayerState createState() => _DeviceMultiplayerState();
}

class _DeviceMultiplayerState extends State<DeviceMultiplayer> {
  LocalMultiplayerGameController _localMultiplayerController;
  bool _displayRoulette = false;
  FixedExtentScrollController _scrollController = FixedExtentScrollController();

  @override
  void initState() {
    super.initState();

    _localMultiplayerController = LocalMultiplayerGameController(
        board: widget.board, onGameEvent: _handleGameEvent);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]).catchError((Object error) {});
  }

  @override
  void dispose() {
    super.dispose();

    _localMultiplayerController.close();

    SystemChrome.setPreferredOrientations([]).catchError((Object error) {});
  }

  void _handleDrop(int x, int y, Tile tile) {
    if (tile is Arrow) {
      Arrow arrow = tile;
      _localMultiplayerController.placeArrow(
          x, y, arrow.player, arrow.direction);
    }
  }

  Widget _dragTileBuilder(BuildContext context, List<Arrow> candidateData,
      List rejectedData, int x, int y) {
    if (candidateData.length == 0) return const SizedBox.expand();

    return ArrowImage(
      player: candidateData[0].player,
      direction: candidateData[0].direction,
      opaque: false,
    );
  }

  Widget _draggableArrow(PlayerColor player, Direction direction) =>
      Draggable<Arrow>(
          maxSimultaneousDrags: 1,
          feedback: const SizedBox.shrink(),
          child: ArrowImage(
            player: player,
            direction: direction,
          ),
          data: Arrow(player: player, direction: direction));

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
      // Possible fixes:
      // - make Wheel inherit ScrollView directly.
      // - make Wheel keep its ScrollView across redraws.
      // - register a post frame callback instead of using a Timer
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                          child: _draggableArrow(
                              PlayerColor.Blue, Direction.Right)),
                      Expanded(
                          child:
                              _draggableArrow(PlayerColor.Blue, Direction.Up)),
                      Expanded(
                          child: Container(
                              child: StreamBuilder<int>(
                                  stream: _localMultiplayerController
                                      .scoreStreams[PlayerColor.Blue.index]
                                      .stream,
                                  initialData: 0,
                                  builder: (context, snapshot) {
                                    return ScoreBox(
                                      score: snapshot.data,
                                      label: widget.players[0],
                                      color: Colors.blue,
                                    );
                                  }))),
                      Expanded(
                          child: _draggableArrow(
                              PlayerColor.Blue, Direction.Left)),
                      Expanded(
                          child: _draggableArrow(
                              PlayerColor.Blue, Direction.Down)),
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
                            child: InputGridOverlay<Arrow>(
                              child: AnimatedGameView(
                                game: _localMultiplayerController.gameStream,
                              ),
                              onDrop: _handleDrop,
                              previewBuilder: _dragTileBuilder,
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
                      Expanded(
                          child: _draggableArrow(
                              PlayerColor.Red, Direction.Right)),
                      Expanded(
                          child:
                              _draggableArrow(PlayerColor.Red, Direction.Up)),
                      Expanded(
                          child: Container(
                              child: StreamBuilder<int>(
                                  stream: _localMultiplayerController
                                      .scoreStreams[PlayerColor.Red.index]
                                      .stream,
                                  initialData: 0,
                                  builder: (context, snapshot) {
                                    return ScoreBox(
                                      score: snapshot.data,
                                      label: widget.players[1],
                                      color: Colors.red,
                                    );
                                  }))),
                      Expanded(
                          child:
                              _draggableArrow(PlayerColor.Red, Direction.Left)),
                      Expanded(
                          child:
                              _draggableArrow(PlayerColor.Red, Direction.Down)),
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
