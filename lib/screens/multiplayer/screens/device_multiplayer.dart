import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyanya_rocket/models/multiplayer_board.dart';
import 'package:nyanya_rocket/screens/multiplayer/device_multiplayer_game_controller.dart';
import 'package:nyanya_rocket/widgets/arrow_image.dart';
import 'package:nyanya_rocket/widgets/countdown.dart';
import 'package:nyanya_rocket/widgets/input_grid_overlay.dart';
import 'package:nyanya_rocket/widgets/game_view/animated_game_view.dart';
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

  @override
  void initState() {
    super.initState();

    _localMultiplayerController =
        LocalMultiplayerGameController(board: widget.board);

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
        ],
      ),
    );
  }
}
