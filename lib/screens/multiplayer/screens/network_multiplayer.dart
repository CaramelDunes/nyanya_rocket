import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../localization/nyanya_localizations.dart';
import '../../../utils.dart';
import '../../../widgets/board/animated_game_view.dart';
import '../../../widgets/board/tiles/arrow_image.dart';
import '../../../widgets/input/input_grid_overlay.dart';
import '../../../widgets/game/score_box.dart';
import '../game_widgets/multiplayer_status_row.dart';
import '../network_client.dart';
import '../game_widgets/event_wheel.dart';

class NetworkMultiplayer extends StatefulWidget {
  final String nickname;
  final InternetAddress serverAddress;
  final int port;
  final int? ticket;
  final Duration gameDuration;

  const NetworkMultiplayer(
      {Key? key,
      required this.nickname,
      required this.serverAddress,
      required this.port,
      this.gameDuration = const Duration(minutes: 3),
      this.ticket})
      : super(key: key);

  @override
  State<NetworkMultiplayer> createState() => _NetworkMultiplayerState();
}

class _NetworkMultiplayerState extends State<NetworkMultiplayer> {
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController();

  late NetworkClient _localMultiplayerController;
  bool _displayRoulette = false;
  bool _hasEnded = false;
  PlayerColor? _myColor;

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

    // Enter fullscreen mode.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _localMultiplayerController.timeStream.addListener(() {
      if (_localMultiplayerController.timeStream.value >
          const Duration(minutes: 3)) {
        setState(() {
          _hasEnded = true;
          _localMultiplayerController.running = false;
        });
      }
    });

    _localMultiplayerController.statusNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _localMultiplayerController.dispose();

    SystemChrome.setPreferredOrientations([]).catchError((Object error) {});

    // Leave fullscreen mode.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    super.dispose();
  }

  void _handleSwipe(int x, int y, Direction direction) {
    _localMultiplayerController.placeArrow(x, y, direction);
  }

  void _handleRegisterSuccess(PlayerColor assignedColor) {
    setState(() {
      _myColor = assignedColor;
    });
  }

  void _handleGameEvent(GameEvent event, Duration animationDuration) {
    if (event != GameEvent.None) {
      // Not 0 to have a card above and under the starting position on the wheel.
      _scrollController.jumpToItem(1);

      setState(() {
        _displayRoulette = true;
      });

      // The scroll controller won't animate if the wheel hasn't been attached
      // to it beforehand.
      // Using a Wheel as a state attribute doesn't work because its build
      // function creates a new ScrollView every time.
      // Possible fixes:
      // - make Wheel inherit ScrollView directly.
      // - make Wheel keep its ScrollView across builds.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateToItem(
            // Not * 4 to have a card above and under on the wheel.
            (GameEvent.values.length - 1) * 3 + event.index - 1,
            duration: const Duration(milliseconds: 1500),
            curve: Curves.decelerate);
      });

      Timer(animationDuration, () {
        if (mounted) {
          setState(() {
            _displayRoulette = false;
          });
        }
      });
    } else {
      print('No');
    }
  }

  Widget _streamBuiltScoreBox(PlayerColor player) {
    if (_localMultiplayerController.players[player.index] == '<empty>') {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<int>(
        valueListenable: _localMultiplayerController.scoreStreams[player.index],
        builder: (_, __, ___) {
          return _buildScoreBox(player);
        });
  }

  Widget _buildScoreBox(PlayerColor player) {
    return ScoreBox(
        label: _localMultiplayerController.players[player.index],
        score: _localMultiplayerController.game.scoreOf(player),
        color: player.color);
  }

  Widget _dragTileBuilder(BuildContext context, List<Direction?> candidateData,
      List rejectedData, int x, int y) {
    if (candidateData.isEmpty) return const SizedBox.expand();

    return ArrowImage(
      direction: candidateData[0]!,
      player: _myColor,
      isHalfTransparent: true,
    );
  }

  Widget _draggableArrow(PlayerColor? player, Direction direction) {
    return Draggable<Direction>(
        maxSimultaneousDrags: 1,
        feedback: const SizedBox.shrink(),
        data: direction,
        child: ArrowImage(
          player: player,
          direction: direction,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              ValueListenableBuilder(
                  valueListenable:
                      _localMultiplayerController.gameEventListenable,
                  builder: (context, GameEvent gameEvent, _) {
                    return MultiplayerStatusRow(
                      // Do not show the current game event when roulette is up
                      // to avoid 'spoiling' the players.
                      displayGameEvent: !_displayRoulette,
                      countdown: _localMultiplayerController.timeStream,
                      currentEvent: gameEvent,
                    );
                  }),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                            children: PlayerColor.values
                                .map((e) => Expanded(
                                    child:
                                        Center(child: _streamBuiltScoreBox(e))))
                                .toList()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AspectRatio(
                          aspectRatio: 12.0 / 9.0,
                          child: InputGridOverlay<Direction>(
                            onSwipe: _handleSwipe,
                            onDrop: _handleSwipe,
                            previewBuilder: _dragTileBuilder,
                            child: AnimatedGameView(
                              game: _localMultiplayerController.running
                                  ? _localMultiplayerController.gameStream
                                  : ValueNotifier(GameState()),
                            ),
                          )),
                    ),
                    Expanded(
                      child: Column(
                          children: Direction.values
                              .map((e) => Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: _draggableArrow(_myColor, e),
                                  )))
                              .toList()),
                    ),
                  ],
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
          ),
          ValueListenableBuilder<NetworkGameStatus>(
              valueListenable: _localMultiplayerController.statusNotifier,
              child: Center(child: _buildWaitingCard()),
              builder: (_, status, widget) {
                return Visibility(
                    visible: status != NetworkGameStatus.playing,
                    child: widget!);
              }),
          if (_hasEnded) _buildEndOfGame()
        ],
      ),
    );
  }

  String _networkGameStatusToString(NetworkGameStatus status) {
    switch (status) {
      case NetworkGameStatus.connectingToServer:
        return NyaNyaLocalizations.of(context).connectingToServerText;
      case NetworkGameStatus.waitingForPlayers:
        return NyaNyaLocalizations.of(context).waitingForPlayersText;
      case NetworkGameStatus.playing:
        return 'Playing...';
      case NetworkGameStatus.ended:
        return 'Game Over';
    }
  }

  Widget _buildWaitingCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _networkGameStatusToString(_localMultiplayerController.status),
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }

  Widget _buildEndOfGame() {
    int maxScore = _localMultiplayerController.game.scores.reduce(max);

    return Container(
      color: Colors.black.withAlpha(128),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 220, maxWidth: 490),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (_myColor != null)
                    Text(
                      (_localMultiplayerController.game.scoreOf(_myColor!) ==
                              maxScore)
                          ? NyaNyaLocalizations.of(context).victoryLabel
                          : NyaNyaLocalizations.of(context).defeatLabel,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: PlayerColor.values
                              .map(
                                (e) => Expanded(
                                  child: Column(
                                    children: [
                                      Text((maxScore ==
                                              _localMultiplayerController.game
                                                  .scoreOf(e))
                                          ? NyaNyaLocalizations.of(context)
                                              .winnerLabel
                                          : ''),
                                      const SizedBox(height: 4.0),
                                      Expanded(child: _buildScoreBox(e)),
                                    ],
                                  ),
                                ),
                              )
                              .toList()),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: Navigator.of(context).pop,
                      child: Text(NyaNyaLocalizations.of(context).back))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
