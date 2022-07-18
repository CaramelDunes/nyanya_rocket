import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../localization/nyanya_localizations.dart';
import '../../models/challenge_data.dart';
import '../../models/named_challenge_data.dart';
import '../../routing/nyanya_route_path.dart';
import '../../widgets/countdown.dart';
import '../../widgets/input/draggable_arrow_grid.dart';
import '../../widgets/board/animated_game_view.dart';
import '../../widgets/board/tiles/arrow_image.dart';
import '../../widgets/game/success_overlay.dart';
import '../../widgets/navigation/guide_action.dart';
import '../../widgets/navigation/settings_action.dart';
import '../puzzle/widgets/draggable_arrow.dart';
import 'challenge_game_controller.dart';
import 'widgets/arrow_drawer.dart';

class Challenge extends StatefulWidget {
  final NamedChallengeData challenge;
  final void Function(Duration time)? onWin;
  final NyaNyaRoutePath? nextRoutePath;
  final Duration? bestTime;
  final String? documentPath;

  const Challenge(
      {Key? key,
      required this.challenge,
      this.nextRoutePath,
      this.onWin,
      this.bestTime,
      this.documentPath})
      : super(key: key);

  @override
  State<Challenge> createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  late ChallengeGameController _challengeController;
  bool _ended = false;

  @override
  void initState() {
    super.initState();

    _challengeController = ChallengeGameController.proxy(
        challenge: widget.challenge.data, onWin: _handleWin);
  }

  @override
  void dispose() {
    _challengeController.dispose();

    super.dispose();
  }

  void _handleSwipe(int x, int y, Direction direction) {
    _challengeController.placeArrow(x, y, direction);
  }

  void _handleDrop(int x, int y, DraggedArrowData arrow) {
    _challengeController.placeArrow(x, y, arrow.direction);
  }

  void _handleWin() {
    setState(() {
      _ended = true;
    });

    widget.onWin?.call(
        const Duration(seconds: 30) - _challengeController.remainingTime);
  }

  Widget _dragTileBuilder(BuildContext context,
      List<DraggedArrowData?> candidateData, List rejectedData, int x, int y) {
    if (candidateData.isEmpty) return const SizedBox.expand();

    return ArrowImage(
      direction: candidateData[0]!.direction,
      player: PlayerColor.Blue,
      isHalfTransparent: true,
    );
  }

  String _objectiveText(BuildContext context) {
    switch (_challengeController.challenge.type) {
      case ChallengeType.getMice:
        return NyaNyaLocalizations.of(context).getMiceObjectiveText;

      case ChallengeType.runAway:
        return NyaNyaLocalizations.of(context).runAwayObjectiveText;

      case ChallengeType.lunchTime:
        return NyaNyaLocalizations.of(context).lunchTimeObjectiveText;

      case ChallengeType.oneHundredMice:
        return NyaNyaLocalizations.of(context).oneHundredMiceObjectiveText;

      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.challenge.name),
        actions: const [SettingsAction(), GuideAction()],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          OrientationBuilder(
            builder: (BuildContext _, Orientation orientation) {
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
                nextRoutePath: widget.nextRoutePath,
                succeededPath: widget.documentPath,
                onPlayAgain: () {
                  _challengeController.reset();
                  setState(() {
                    _ended = false;
                  });
                },
              )),
        ],
      ),
    );
  }

  Widget _buildPortrait() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          _objectiveText(context),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildElapsedTime(),
            _buildBestTime(),
            _buildTargetCount(),
            _buildPlayResetButton(Orientation.landscape)
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
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
          child: DraggableArrowGrid<DraggedArrowData>(
            onDrop: _handleDrop,
            onSwipe: _handleSwipe,
            previewBuilder: _dragTileBuilder,
            onWillAccept: _handleOnWillAccept,
            child: AnimatedGameView(
              game: _challengeController.gameStream,
              mistake: _challengeController.mistake,
            ),
          )),
    );
  }

  Widget _buildElapsedTime() {
    return RepaintBoundary(
      child: ValueListenableBuilder<Duration>(
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
          }),
    );
  }

  Widget _buildTargetCount() {
    return ValueListenableBuilder<int>(
        valueListenable: _challengeController.scoreStream,
        builder: (BuildContext context, int value, Widget? child) {
          return Text(
            '$value / ${_challengeController.targetScore}',
            style: Theme.of(context).textTheme.headline6,
          );
        });
  }

  Widget _buildBestTime() {
    return Text(
      (widget.bestTime != null && widget.bestTime != Duration.zero)
          ? Countdown.formatDuration(widget.bestTime!)
          : '',
      style:
          Theme.of(context).textTheme.headline6!.copyWith(color: Colors.green),
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

  bool _handleOnWillAccept(int x, int y, Direction? arrowDirection) {
    return _challengeController.game.board.tiles[x][y] is Empty;
  }
}
