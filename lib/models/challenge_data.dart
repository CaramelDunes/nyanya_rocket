import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

class ChallengeType {
  final int index;

  const ChallengeType._internal(this.index);

  @override
  String toString() => '${_names[index]}';

  String toLocalizedString(BuildContext context) {
    switch (index) {
      case 0:
        return NyaNyaLocalizations.of(context).challengeGetMiceType;

      case 1:
        return NyaNyaLocalizations.of(context).challengeRunAwayType;

      case 2:
        return NyaNyaLocalizations.of(context).challengeLunchTimeType;

      case 3:
        return NyaNyaLocalizations.of(context).challengeOneHundredMiceType;

      default:
        return '';
    }
  }

  static const GetMice = const ChallengeType._internal(0);
  static const RunAway = const ChallengeType._internal(1);
  static const LunchTime = const ChallengeType._internal(2);
  static const OneHundredMice = const ChallengeType._internal(3);

//  static const CatSoccer = const ChallengeType._internal(4);

  static const List<ChallengeType> values = const <ChallengeType>[
    GetMice, // Like Puzzle, without cats
    RunAway, // Like Puzzle, with cats
    LunchTime, // Feed all Mice to Cat
    OneHundredMice,
//    CatSoccer, // Needs an AI
  ];

  static const List<String> _names = const <String>[
    'Get Mice', // Like Puzzle, without cats
    'Run Away', // Like Puzzle, with cats
    'Lunch Time', // Feed all Mice to Cat
    'One Hundred Mice',
//    'Cat Soccer', // Needs an AI
  ];
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
