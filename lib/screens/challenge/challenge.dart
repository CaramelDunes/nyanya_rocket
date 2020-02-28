import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/models/named_challenge_data.dart';
import 'package:nyanya_rocket/screens/challenge/challenge_game_controller.dart';
import 'package:nyanya_rocket/screens/challenge/widgets/arrow_drawer.dart';
import 'package:nyanya_rocket/widgets/arrow_image.dart';
import 'package:nyanya_rocket/widgets/countdown.dart';
import 'package:nyanya_rocket/widgets/game_view/animated_game_view.dart';
import 'package:nyanya_rocket/widgets/input_grid_overlay.dart';
import 'package:nyanya_rocket/widgets/success_overlay.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class Challenge extends StatefulWidget {
  final NamedChallengeData challenge;
  final void Function(Duration time) onWin;
  final bool hasNext;
  final Duration bestTime;

  Challenge(
      {@required this.challenge,
      @required this.hasNext,
      this.onWin,
      this.bestTime});

  @override
  _ChallengeState createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  ChallengeGameController _challengeController;
  bool _ended = false;

  @override
  void initState() {
    super.initState();

    _challengeController = ChallengeGameController.proxy(
        challenge: widget.challenge.challengeData, onWin: _handleWin);
  }

  @override
  void dispose() {
    _challengeController.close();

    super.dispose();
  }

  void _handleSwipeAndDrop(int x, int y, Direction direction) {
    _challengeController.placeArrow(x, y, direction);
  }

  void _handleWin() {
    setState(() {
      _ended = true;
    });

    if (widget.onWin != null) {
      widget.onWin(Duration(seconds: 30) - _challengeController.remainingTime);
    }
  }

  Widget _dragTileBuilder(BuildContext context, List<Direction> candidateData,
      List rejectedData, int x, int y) {
    if (candidateData.isEmpty) return const SizedBox.expand();

    return ArrowImage(
      direction: candidateData[0],
      player: PlayerColor.Blue,
      opaque: false,
    );
  }

  String _objectiveText(BuildContext context) {
    switch (_challengeController.challenge.type) {
      case ChallengeType.GetMice:
        return NyaNyaLocalizations.of(context).getMiceObjectiveText;
        break;

      case ChallengeType.RunAway:
        return NyaNyaLocalizations.of(context).runAwayObjectiveText;
        break;

      case ChallengeType.LunchTime:
        return NyaNyaLocalizations.of(context).lunchTimeObjectiveText;
        break;

      case ChallengeType.OneHundredMice:
        return NyaNyaLocalizations.of(context).oneHundredMiceObjectiveText;
        break;

      default:
        return '';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.challenge.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/tutorial');
            },
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              if (orientation == Orientation.portrait) {
                return _buildPortrait();
              } else {
                return _buildLandscape();
              }
            },
          ),
          Visibility(
              visible: _ended,
              child: SuccessOverlay(
                succeededName: widget.challenge.name,
                hasNext: widget.hasNext,
                canPlayAgain: true,
              )),
        ],
      ),
    );
  }

  Widget _buildPortrait() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          _objectiveText(context),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildElapsedTime(),
            _buildBestTime(),
            _buildTargetCount(),
          ],
        ),
        _buildGameView(),
        ArrowDrawer(running: _challengeController.running),
        _buildPlayResetButton(Orientation.portrait)
      ],
    );
  }

  Widget _buildLandscape() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildElapsedTime(),
            _buildBestTime(),
            _buildTargetCount(),
            _buildPlayResetButton(Orientation.landscape)
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildGameView(),
        ),
        ArrowDrawer(running: _challengeController.running),
      ],
    );
  }

  Widget _buildGameView() {
    return Material(
        elevation: 8.0,
        child: AspectRatio(
            aspectRatio: 12.0 / 9.0,
            child: InputGridOverlay<Direction>(
              child: AnimatedGameView(
                game: _challengeController.gameStream,
                mistake: _challengeController.mistake,
              ),
              onDrop: _handleSwipeAndDrop,
              onSwipe: _handleSwipeAndDrop,
              previewBuilder: _dragTileBuilder,
            )));
  }

  Widget _buildElapsedTime() {
    return ValueListenableBuilder<Duration>(
        valueListenable: _challengeController.timeStream,
        builder: (context, remaining, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Countdown(
                remaining: remaining,
                color: _challengeController.remainingTime == Duration.zero
                    ? Colors.red
                    : null),
          );
        });
  }

  Widget _buildTargetCount() {
    return ValueListenableBuilder<int>(
        valueListenable: _challengeController.scoreStream,
        builder: (BuildContext context, int value, Widget _) {
          return Text(
            '$value / ${_challengeController.targetScore}',
            style: Theme.of(context).textTheme.headline6,
          );
        });
  }

  Widget _buildBestTime() {
    return Text(
      (widget.bestTime != null && widget.bestTime != Duration.zero)
          ? Countdown.formatDuration(widget.bestTime)
          : '',
      style:
          Theme.of(context).textTheme.headline6.copyWith(color: Colors.green),
    );
  }

  Widget _buildPlayResetButton(Orientation orientation) {
    return Card(
      elevation: 8,
      color: _challengeController.running ||
              _challengeController.hasMistake ||
              _challengeController.remainingTime == Duration.zero
          ? Colors.red
          : Colors.green,
      child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
                _challengeController.running ||
                        _challengeController.hasMistake ||
                        _challengeController.remainingTime == Duration.zero
                    ? Icons.replay
                    : Icons.play_circle_outline,
                size: 70),
          ),
          onTap: () {
            setState(() {
              if (_challengeController.running ||
                  _challengeController.hasMistake ||
                  _challengeController.remainingTime == Duration.zero) {
                _challengeController.reset();
              } else {
                _challengeController.running = true;
              }
            });
          }),
    );
  }
}
