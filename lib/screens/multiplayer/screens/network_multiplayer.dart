import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/multiplayer/game_widgets/event_wheel.dart';
import 'package:nyanya_rocket/screens/multiplayer/network_client.dart';
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
  final Duration gameDuration;

  const NetworkMultiplayer(
      {Key key,
      @required this.nickname,
      @required this.serverAddress,
      @required this.port,
      this.gameDuration = const Duration(minutes: 3),
      this.ticket})
      : super(key: key);

  @override
  _NetworkMultiplayerState createState() => _NetworkMultiplayerState();
}

class _NetworkMultiplayerState extends State<NetworkMultiplayer> {
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController();

  NetworkClient _localMultiplayerController;
  bool _displayRoulette = false;
  bool _hasEnded = false;
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

    _localMultiplayerController.timeStream.addListener(() {
      if (_localMultiplayerController.timeStream.value > Duration(minutes: 3)) {
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

    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);

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
            duration: Duration(milliseconds: 1500),
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
    if (_localMultiplayerController.players[player.index] == '<empty>' ||
        (!_localMultiplayerController.running &&
            _localMultiplayerController.game.scoreOf(player) == 0)) {
      return SizedBox.shrink();
    }

    return ValueListenableBuilder<int>(
        valueListenable: _localMultiplayerController.scoreStreams[player.index],
        builder: (_, __, ___) {
          return _buildScoreBox(player);
        });
  }

  Color _playerColorToColor(PlayerColor player) {
    switch (player) {
      case PlayerColor.Blue:
        return Colors.blue;
        break;

      case PlayerColor.Red:
        return Colors.red;
        break;

      case PlayerColor.Green:
        return Colors.green;
        break;

      case PlayerColor.Yellow:
        return Colors.yellow;
        break;

      default:
        return Colors.black;
        break;
    }
  }

  Widget _buildScoreBox(PlayerColor player) {
    return ScoreBox(
        label: _localMultiplayerController.players[player.index],
        score: _localMultiplayerController.game.scoreOf(player),
        color: _playerColorToColor(player));
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
    return Container(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    _displayRoulette
                        ? ''
                        : EventWheel.eventName(
                            _localMultiplayerController.game.currentEvent),
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
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
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                            children: PlayerColor.values
                                .map((e) =>
                                    Expanded(child: _streamBuiltScoreBox(e)))
                                .toList()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                      child: Material(
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
                child: Container(
              width: 450,
              height: 200,
              child: EventWheel(
                scrollController: _scrollController,
              ),
            )),
          ),
          ValueListenableBuilder<NetworkGameStatus>(
              valueListenable: _localMultiplayerController.statusNotifier,
              child: _buildWaitingCard(),
              builder: (_, status, widget) {
                return Visibility(
                    visible: status != NetworkGameStatus.Playing,
                    child: widget);
              }),
          if (_hasEnded) _buildEndOfGame()
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

  Widget _buildEndOfGame() {
    int maxScore = _localMultiplayerController.game.scores.reduce(max);

    return Container(
      color: Colors.black.withAlpha(128),
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (_localMultiplayerController.game.scoreOf(_myColor) ==
                          maxScore)
                      ? NyaNyaLocalizations.of(context).victoryLabel
                      : NyaNyaLocalizations.of(context).defeatLabel,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 8.0),
                Row(
                    mainAxisSize: MainAxisSize.min,
                    children: PlayerColor.values
                        .map(
                          (e) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text((maxScore ==
                                      _localMultiplayerController.game
                                          .scoreOf(e))
                                  ? NyaNyaLocalizations.of(context).winnerLabel
                                  : ''),
                              _buildScoreBox(e),
                            ],
                          ),
                        )
                        .toList())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
