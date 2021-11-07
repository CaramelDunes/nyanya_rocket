import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

enum ChallengeType {
  getMice, // Like Puzzle, without cats
  runAway, // Like Puzzle, with cats
  lunchTime, // Feed all Mice to Cat
  oneHundredMice,
  // CatSoccer // Needs an AI
}

extension LocalizedChallengeType on ChallengeType {
  static const List<String> _names = <String>[
    'Get Mice', // Like Puzzle, without cats
    'Run Away', // Like Puzzle, with cats
    'Lunch Time', // Feed all Mice to Cat
    'One Hundred Mice',
    // 'Cat Soccer', // Needs an AI
  ];

  String toPrettyString() => _names[index];

  String toLocalizedString(BuildContext context) {
    switch (this) {
      case ChallengeType.getMice:
        return NyaNyaLocalizations.of(context).challengeGetMiceType;
      case ChallengeType.runAway:
        return NyaNyaLocalizations.of(context).challengeRunAwayType;
      case ChallengeType.lunchTime:
        return NyaNyaLocalizations.of(context).challengeLunchTimeType;
      case ChallengeType.oneHundredMice:
        return NyaNyaLocalizations.of(context).challengeOneHundredMiceType;
    }
  }
}

class ChallengeData {
  final String gameData;
  final ChallengeType type;

  ChallengeData({required this.gameData, required this.type});

  ChallengeData.withBorder({required this.type})
      : gameData =
            jsonEncode((GameState()..board = Board.withBorder()).toJson());

  GameState getGame() => GameState.fromJson(jsonDecode(gameData));

  static ChallengeData fromJson(Map<String, dynamic> json) {
    return ChallengeData(
        gameData: json['gameData'], type: ChallengeType.values[json['type']]);
  }

  Map<String, dynamic> toJson() => {'gameData': gameData, 'type': type.index};
}
