import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/screens/challenge/challenge_game_controller.dart';
import 'package:nyanya_rocket/screens/challenge/widgets/arrow_drawer.dart';
import 'package:nyanya_rocket/widgets/arrow_image.dart';
import 'package:nyanya_rocket/widgets/countdown.dart';
import 'package:nyanya_rocket/widgets/input_grid_overlay.dart';
import 'package:nyanya_rocket/widgets/game_view/animated_game_view.dart';
import 'package:nyanya_rocket/widgets/success_overlay.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class ChallengePopData {
  final bool cleared;
  final bool starred;

  ChallengePopData(this.cleared, this.starred);
}

class Challenge extends StatefulWidget {
  final ChallengeData challenge;
  final void Function(Duration time) onWin;

  Challenge({@required this.challenge, this.onWin});

  @override
  _ChallengeState createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  ChallengeGameController _challengeController;
  ArrowDrawer _availableArrows;
  bool _ended = false;

  @override
  void initState() {
    super.initState();

    _challengeController = ChallengeGameController.proxy(
        challenge: widget.challenge, onWin: _handleWin);
    _availableArrows = ArrowDrawer(
      challengeGameController: _challengeController,
    );
  }

  @override
  void dispose() {
    super.dispose();

    _challengeController.close();
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
    if (candidateData.length == 0) return const SizedBox.expand();

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
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              return Flex(
                direction: orientation == Orientation.portrait
                    ? Axis.vertical
                    : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: orientation == Orientation.portrait
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Spacer(),
                  Visibility(
                    visible: orientation == Orientation.portrait,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                            flex: 3,
                            child: Text(
                              _objectiveText(context),
                              textAlign: TextAlign.center,
                            )),
                        Flexible(
                          flex: 1,
                          child: StreamBuilder<int>(
                              stream: _challengeController.scoreStream.stream,
                              initialData: 0,
                              builder: (context, snapshot) {
                                return Text(
                                    '${snapshot.data} / ${_challengeController.targetScore}');
                              }),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<Duration>(
                      stream: _challengeController.timeStream.stream,
                      initialData: Duration(seconds: 30),
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Countdown(remaining: snapshot.data),
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                        )),
                  ),
                  _availableArrows,
                  IconButton(
                    icon: Icon(Icons.restore),
                    onPressed: () {
                      setState(() {
                        _challengeController.pleaseReset();
                      });
                    },
                  )
                ],
              );
            },
          ),
          Visibility(
              visible: _ended,
              child: SuccessOverlay(succeededName: widget.challenge.name)),
        ],
      ),
    );
  }
}
