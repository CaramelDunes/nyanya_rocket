import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../models/multiplayer_board.dart';
import '../../../widgets/input/draggable_arrow_grid.dart';
import '../../../widgets/board/animated_game_view.dart';
import '../../../widgets/board/tiles/arrow_image.dart';
import '../../../widgets/game/score_box.dart';
import '../../puzzle/widgets/draggable_arrow.dart';
import '../device_multiplayer_game_controller.dart';
import '../game_widgets/event_wheel.dart';
import '../game_widgets/multiplayer_status_row.dart';
import '../../../utils.dart';

class DraggedArrowDataWithPlayer extends DraggedArrowData {
  final PlayerColor player;

  DraggedArrowDataWithPlayer(
      {required this.player, required Direction direction})
      : super(direction: direction);
}

class LocalDuel extends StatefulWidget {
  final MultiplayerBoard board;
  final List<String> players;
  final Duration duration;

  const LocalDuel(
      {super.key,
      required this.board,
      required this.players,
      required this.duration});

  @override
  State<LocalDuel> createState() => _LocalDuelState();
}

class _LocalDuelState extends State<LocalDuel> {
  late LocalMultiplayerGameController _localMultiplayerController;
  bool _displayRoulette = false;
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController();

  @override
  void initState() {
    super.initState();

    _localMultiplayerController = LocalMultiplayerGameController(
        board: widget.board, onGameEvent: _handleGameEvent);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]).catchError((Object error) {});

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _localMultiplayerController.dispose();

    SystemChrome.setPreferredOrientations([]).catchError((Object error) {});

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    super.dispose();
  }

  void _handleDrop(int x, int y, DraggedArrowDataWithPlayer arrow) {
    _localMultiplayerController.placeArrow(x, y, arrow.player, arrow.direction);
  }

  Widget _dragTileBuilder(
      BuildContext context,
      List<DraggedArrowDataWithPlayer?> candidateData,
      List rejectedData,
      int x,
      int y) {
    if (candidateData.isEmpty) return const SizedBox.expand();

    final candidate = candidateData.first;
    if (candidate != null) {
      return ArrowImage(
        player: candidate.player,
        direction: candidate.direction,
        isHalfTransparent: true,
      );
    } else {
      return const SizedBox.expand();
    }
  }

  Widget _draggableArrow(PlayerColor player, Direction direction) {
    return Draggable<Arrow>(
        maxSimultaneousDrags: 1,
        feedback: const SizedBox.shrink(),
        data: Arrow(player: player, direction: direction),
        child: ArrowImage(
          player: player,
          direction: direction,
        ));
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
            duration: const Duration(milliseconds: 1500),
            curve: Curves.decelerate);
      });

      Timer(const Duration(seconds: 3), () {
        setState(() {
          _displayRoulette = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Column(
            children: [
              MultiplayerStatusRow(
                // Do not show the current game event when roulette is up
                // to avoid 'spoiling' the players.
                displayGameEvent: !_displayRoulette,
                countdown: _localMultiplayerController.timeStream,
                currentEvent: _localMultiplayerController.game.currentEvent,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: _buildArrowScoreColumn(PlayerColor.Blue),
                        ),
                      ),
                      Flexible(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Material(
                              elevation: 8.0,
                              child: AspectRatio(
                                  aspectRatio: 12.0 / 9.0,
                                  child: DraggableArrowGrid<
                                      DraggedArrowDataWithPlayer>(
                                    onDrop: _handleDrop,
                                    previewBuilder: _dragTileBuilder,
                                    child: AnimatedGameView(
                                      game: _localMultiplayerController
                                          .gameStream,
                                    ),
                                  )),
                            ),
                          )),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: _buildArrowScoreColumn(PlayerColor.Red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: _displayRoulette,
            child: Center(
                child: SizedBox(
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

  Widget _buildArrowScoreColumn(PlayerColor player) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: _draggableArrow(player, Direction.Right)),
        const SizedBox(height: 4.0),
        Expanded(child: _draggableArrow(player, Direction.Up)),
        const SizedBox(height: 4.0),
        Expanded(
            child: ValueListenableBuilder<int>(
                valueListenable:
                    _localMultiplayerController.scoreStreams[player.index],
                builder: (context, score, snapshot) {
                  return ScoreBox(
                    score: score,
                    label: widget.players[player.index],
                    color: player.color,
                  );
                })),
        const SizedBox(height: 4.0),
        Expanded(child: _draggableArrow(player, Direction.Left)),
        const SizedBox(height: 4.0),
        Expanded(child: _draggableArrow(player, Direction.Down)),
      ],
    );
  }
}
