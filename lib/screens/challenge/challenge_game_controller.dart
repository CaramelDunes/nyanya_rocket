import 'package:flutter/material.dart';

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

  final List<ArrowPosition> placedArrows = [];
  final void Function() onWin;

  Duration _remainingTime = Duration(seconds: 30);
  final ValueNotifier<Duration> timeStream = ValueNotifier(Duration.zero);

  ValueNotifier<BoardPosition?> _mistake = ValueNotifier(null);

  Iterable<Cat>? _preMistakeCats;
  Iterable<Mouse>? _preMistakeMice;

  ChallengeGameController({required this.challenge, required this.onWin})
      : super(challenge.getGame(), ChallengeGameSimulator());

  factory ChallengeGameController.proxy(
      {required ChallengeData challenge, required void Function() onWin}) {
    switch (challenge.type) {
      case ChallengeType.RunAway:
      case ChallengeType.GetMice:
        return RunAwayGameController(challenge: challenge, onWin: onWin);

      case ChallengeType.LunchTime:
        return LunchTimeGameController(challenge: challenge, onWin: onWin);

      case ChallengeType.OneHundredMice:
        return OneHundredMiceGameController(challenge: challenge, onWin: onWin);
    }
  }

  @override
  void dispose() {
    timeStream.dispose();

    super.dispose();
  }

  ValueNotifier<BoardPosition?> get mistake => _mistake;

  @protected
  void mistakeMade(BoardPosition position) {
    _mistake.value = position;
    running = false;
    _preMistakeCats = game.cats;
    _preMistakeMice = game.mice;
  }

  bool placeArrow(int x, int y, Direction direction) {
    if (running && game.board.tiles[x][y] is Empty) {
      if (game.board.tiles[x][y] is Empty) {
        int count = 0;
        ArrowPosition? last;
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

        if (count >= 3 && last != null) {
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
  void beforeUpdate() {
    _remainingTime -= GameTicker.updatePeriod;

    if (_remainingTime.isNegative) {
      running = false;
      _remainingTime = Duration.zero;
    }

    timeStream.value = Duration(seconds: 30) - _remainingTime;
  }

  @override
  void afterUpdate() {
    if (_mistake.value != null) {
      game.cats = _preMistakeCats!.toList();
      game.mice = _preMistakeMice!.toList();
    }

    updateGame();

    super.afterUpdate();
  }

  @protected
  void onReset() {}

  void reset() {
    running = false;
    _mistake.value = null;
    _remainingTime = Duration(seconds: 30);
    timeStream.value = Duration.zero;
    gameState = challenge.getGame();
    onReset();
    updateGame();
  }

  Duration get remainingTime => _remainingTime;

  ValueNotifier<int> get scoreStream;

  int get targetScore;

  bool get hasMistake => _mistake.value != null;
}
