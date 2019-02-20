import 'dart:async';

import 'package:meta/meta.dart';
import 'package:nyanya_rocket/blocs/local_game_controller.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/screens/challenge/lunch_time_game_controller.dart';
import 'package:nyanya_rocket/screens/challenge/one_hundred_mice_game_controller.dart';
import 'package:nyanya_rocket/screens/challenge/run_away_game_controller.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class ArrowPosition {
  final int x;
  final int y;

  ArrowPosition(this.x, this.y);
}

abstract class ChallengeGameController extends LocalGameController {
  final ChallengeData challenge;

  final List<ArrowPosition> placedArrows = List();
  final void Function() onWin;

  Duration _remainingTime = Duration(seconds: 30);
  final StreamController<Duration> timeStream = StreamController();

  bool _pleaseReset = false;

  BoardPosition _mistake;

  ChallengeGameController({@required this.challenge, this.onWin})
      : super(challenge.getGame()) {
    running = true;
    pauseFor(Duration(seconds: 3));
  }

  factory ChallengeGameController.proxy(
      {@required ChallengeData challenge, void Function() onWin}) {
    ChallengeGameController gameController;

    switch (challenge.type) {
      case ChallengeType.RunAway:
      case ChallengeType.GetMice:
        gameController =
            RunAwayGameController(challenge: challenge, onWin: onWin);
        break;

      case ChallengeType.LunchTime:
        gameController =
            LunchTimeGameController(challenge: challenge, onWin: onWin);
        break;

      case ChallengeType.OneHundredMice:
        gameController =
            OneHundredMiceGameController(challenge: challenge, onWin: onWin);
        break;
    }

    return gameController;
  }

  @override
  void close() {
    super.close();

    timeStream.close();
  }

  BoardPosition get mistake => _mistake;

  @protected
  void mistakeMade(BoardPosition position) {
    _mistake = position;
    pauseFor(Duration(seconds: 3));
    pleaseReset();
  }

  bool placeArrow(int x, int y, Direction direction) {
    if (!paused && running && game.board.tiles[x][y] is Empty) {
      if (game.board.tiles[x][y] is Empty) {
        int count = 0;
        ArrowPosition last;
        int lastExpiration = Arrow.defaultExpiration;

        for (int i = 0; i < Board.width; i++) {
          // TODO Get rid of that ugly thing
          for (int j = 0; j < Board.height; j++) {
            if (game.board.tiles[i][j] is Arrow) {
              Arrow arrow = game.board.tiles[i][j] as Arrow;
              if (PlayerColor.Blue == arrow.player) {
                count++;

                if (arrow.expiration < lastExpiration) {
                  last = ArrowPosition(i, j);
                  lastExpiration = arrow.expiration;
                }
              }
            }
          }
        }

        if (count >= 3) {
          game.board.tiles[last.x][last.y] = Empty();
        }

        game.board.tiles[x][y] =
            Arrow(player: PlayerColor.Blue, direction: direction);
      }
      placedArrows.add(ArrowPosition(x, y));
      updateGame();

      return true;
    }

    return false;
  }

  @mustCallSuper
  @override
  void beforeTick() {
    _remainingTime -= Duration(milliseconds: 16);
    timeStream.add(_remainingTime);

    if (_remainingTime.isNegative) {
      running = false;
    }

    if (_pleaseReset) {
      _reset();
    }
  }

  @protected
  void onReset() {}

  void _reset() {
    running = true;
    _mistake = null;
    pauseFor(Duration(seconds: 3));
    _remainingTime = Duration(seconds: 30);
    timeStream.add(_remainingTime);
    onReset();
    game = challenge.getGame();
    _pleaseReset = false;
  }

  @protected
  void pleaseReset() => _pleaseReset = true;

  Duration get remainingTime => _remainingTime;
}
