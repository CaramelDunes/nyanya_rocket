import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:nyanya_rocket/models/challenge_data.dart';
import 'package:nyanya_rocket/models/challenge_progression_manager.dart';
import 'package:nyanya_rocket/models/named_challenge_data.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/screens/challenge/challenge.dart';
import 'package:nyanya_rocket/widgets/completion_indicator.dart';
import 'package:nyanya_rocket/widgets/game_view/static_game_view.dart';
import 'package:nyanya_rocket/widgets/success_overlay.dart';
import 'package:slugify/slugify.dart';

class OriginalChallenges extends StatefulWidget {
  static final ChallengeProgressionManager progression =
      ChallengeProgressionManager();

  static final List<NamedChallengeData> challenges = [
    NamedChallengeData(
        type: ChallengeType.GetMice,
        name: ' #1',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,0,0,0,3,1,2,0,0],[2,0,3,1,0,0,3,0,1],[2,0,0,0,0,0,2,0,0],[2,0,0,0,0,0,2,0,0],[2,0,2,0,0,0,3,0,1],[2,0,1,1,3,2,2,0,0],[2,0,0,0,2,2,3,0,1],[2,0,0,0,2,2,2,0,0],[2,2,0,0,0,2,2,0,0],[2,1,0,0,0,2,3,1,1],[3,0,0,0,2,2,2,0,0]]},"entities":[{"type":1,"position":{"x":2,"y":8,"direction":0}},{"type":1,"position":{"x":3,"y":8,"direction":0}},{"type":1,"position":{"x":7,"y":8,"direction":0}},{"type":1,"position":{"x":8,"y":8,"direction":0}},{"type":1,"position":{"x":9,"y":6,"direction":2}},{"type":1,"position":{"x":8,"y":6,"direction":2}},{"type":1,"position":{"x":4,"y":6,"direction":2}},{"type":1,"position":{"x":3,"y":6,"direction":2}},{"type":1,"position":{"x":4,"y":8,"direction":1}},{"type":1,"position":{"x":4,"y":7,"direction":1}},{"type":1,"position":{"x":9,"y":8,"direction":1}},{"type":1,"position":{"x":9,"y":7,"direction":1}},{"type":1,"position":{"x":7,"y":6,"direction":3}},{"type":1,"position":{"x":7,"y":7,"direction":3}},{"type":1,"position":{"x":2,"y":6,"direction":3}},{"type":1,"position":{"x":2,"y":7,"direction":3}}]}'),
    NamedChallengeData(
        type: ChallengeType.RunAway,
        name: ' #1',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":3,"player":0}]],"walls":[[3,1,3,3,3,1,1,3,1],[2,0,2,2,2,3,2,2,0],[2,0,2,1,0,2,2,2,0],[2,0,1,1,1,0,0,0,0],[2,0,3,1,1,1,1,0,0],[2,0,0,3,1,1,2,0,0],[2,0,0,1,1,1,0,2,0],[2,0,3,1,1,1,1,0,0],[2,0,0,3,1,1,2,0,0],[2,0,0,1,1,1,0,2,0],[2,0,1,1,1,1,1,0,0],[2,0,3,1,1,1,1,2,0]]},"entities":[{"type":0,"position":{"x":11,"y":2,"direction":3}},{"type":0,"position":{"x":0,"y":2,"direction":0}},{"type":1,"position":{"x":4,"y":2,"direction":0}},{"type":1,"position":{"x":5,"y":2,"direction":0}},{"type":1,"position":{"x":7,"y":2,"direction":0}},{"type":1,"position":{"x":8,"y":2,"direction":0}},{"type":1,"position":{"x":4,"y":6,"direction":1}},{"type":1,"position":{"x":4,"y":5,"direction":1}},{"type":1,"position":{"x":4,"y":4,"direction":1}},{"type":1,"position":{"x":4,"y":3,"direction":1}},{"type":1,"position":{"x":7,"y":6,"direction":1}},{"type":1,"position":{"x":7,"y":5,"direction":1}},{"type":1,"position":{"x":7,"y":4,"direction":1}},{"type":1,"position":{"x":7,"y":3,"direction":1}},{"type":1,"position":{"x":9,"y":2,"direction":3}},{"type":1,"position":{"x":9,"y":3,"direction":3}},{"type":1,"position":{"x":9,"y":5,"direction":3}},{"type":1,"position":{"x":9,"y":4,"direction":3}},{"type":1,"position":{"x":9,"y":6,"direction":2}},{"type":1,"position":{"x":8,"y":6,"direction":2}},{"type":1,"position":{"x":6,"y":6,"direction":2}},{"type":1,"position":{"x":5,"y":6,"direction":2}},{"type":1,"position":{"x":6,"y":2,"direction":3}},{"type":1,"position":{"x":6,"y":3,"direction":3}},{"type":1,"position":{"x":6,"y":4,"direction":3}},{"type":1,"position":{"x":6,"y":5,"direction":3}}]}'),
    NamedChallengeData(
        type: ChallengeType.LunchTime,
        name: ' #1',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,3,3,3,1,1,3,3,3],[2,0,0,2,1,0,0,0,0],[2,0,0,0,2,0,0,0,0],[2,0,0,0,2,0,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,2,0,0,0,0],[2,0,0,0,0,2,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,2,0,0,0],[2,0,0,0,0,2,0,0,0],[2,0,0,0,0,0,2,0,0],[2,2,2,2,1,0,2,2,2]]},"entities":[{"type":1,"position":{"x":1,"y":0,"direction":0}},{"type":1,"position":{"x":0,"y":0,"direction":0}},{"type":1,"position":{"x":0,"y":1,"direction":0}},{"type":1,"position":{"x":1,"y":1,"direction":0}},{"type":1,"position":{"x":2,"y":1,"direction":0}},{"type":1,"position":{"x":0,"y":2,"direction":0}},{"type":1,"position":{"x":1,"y":2,"direction":0}},{"type":1,"position":{"x":3,"y":2,"direction":0}},{"type":1,"position":{"x":2,"y":2,"direction":0}},{"type":1,"position":{"x":2,"y":0,"direction":0}},{"type":1,"position":{"x":3,"y":0,"direction":0}},{"type":1,"position":{"x":3,"y":1,"direction":0}},{"type":1,"position":{"x":4,"y":0,"direction":0}},{"type":1,"position":{"x":5,"y":0,"direction":0}},{"type":1,"position":{"x":4,"y":1,"direction":0}},{"type":1,"position":{"x":5,"y":1,"direction":0}},{"type":1,"position":{"x":4,"y":2,"direction":0}},{"type":1,"position":{"x":5,"y":2,"direction":0}},{"type":1,"position":{"x":11,"y":8,"direction":2}},{"type":1,"position":{"x":11,"y":6,"direction":2}},{"type":1,"position":{"x":11,"y":7,"direction":2}},{"type":1,"position":{"x":10,"y":6,"direction":2}},{"type":1,"position":{"x":10,"y":7,"direction":2}},{"type":1,"position":{"x":10,"y":8,"direction":2}},{"type":1,"position":{"x":9,"y":8,"direction":2}},{"type":1,"position":{"x":9,"y":7,"direction":2}},{"type":1,"position":{"x":9,"y":6,"direction":2}},{"type":1,"position":{"x":8,"y":6,"direction":2}},{"type":1,"position":{"x":8,"y":7,"direction":2}},{"type":1,"position":{"x":8,"y":8,"direction":2}},{"type":1,"position":{"x":7,"y":8,"direction":2}},{"type":1,"position":{"x":7,"y":7,"direction":2}},{"type":1,"position":{"x":7,"y":6,"direction":2}},{"type":1,"position":{"x":6,"y":6,"direction":2}},{"type":1,"position":{"x":6,"y":7,"direction":2}},{"type":1,"position":{"x":6,"y":8,"direction":2}},{"type":0,"position":{"x":10,"y":5,"direction":2}},{"type":0,"position":{"x":7,"y":5,"direction":2}},{"type":1,"position":{"x":5,"y":6,"direction":2}},{"type":1,"position":{"x":5,"y":7,"direction":2}},{"type":1,"position":{"x":5,"y":8,"direction":2}}]}'),
    NamedChallengeData(
        type: ChallengeType.OneHundredMice,
        name: ' #1',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":4,"direction":0},{"type":4,"direction":0}],[{"type":0},{"type":0},{"type":0},{"type":3,"player":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":3,"player":0},{"type":3,"player":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":3,"player":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":4,"direction":2},{"type":4,"direction":2},{"type":0},{"type":3,"player":0},{"type":3,"player":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,3,1,1,1,1,3,1],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,2,0,0,0,0],[2,0,0,1,3,0,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,2,2,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,2,0,0,0,0,2,0]]},"entities":[]}'),
    NamedChallengeData(
        type: ChallengeType.GetMice,
        name: ' #2',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,3,1,1,3,1,1],[2,0,0,0,0,0,0,0,0],[2,0,0,2,0,0,2,0,0],[3,1,1,3,1,1,3,0,1],[2,0,0,2,0,0,0,0,0],[2,0,0,2,0,0,2,0,0],[3,0,1,3,0,1,3,1,1],[2,0,0,0,0,0,0,0,0],[2,0,0,2,0,0,2,0,0],[3,0,1,3,1,1,3,1,1],[2,0,0,0,0,0,0,0,0],[2,0,0,2,0,0,2,0,0]]},"entities":[{"type":1,"position":{"x":0,"y":0,"direction":0}},{"type":1,"position":{"x":1,"y":0,"direction":0}},{"type":1,"position":{"x":3,"y":0,"direction":0}},{"type":1,"position":{"x":4,"y":0,"direction":0}},{"type":1,"position":{"x":6,"y":0,"direction":0}},{"type":1,"position":{"x":7,"y":0,"direction":0}},{"type":1,"position":{"x":9,"y":0,"direction":0}},{"type":1,"position":{"x":10,"y":0,"direction":0}},{"type":1,"position":{"x":0,"y":3,"direction":0}},{"type":1,"position":{"x":1,"y":3,"direction":0}},{"type":1,"position":{"x":3,"y":3,"direction":0}},{"type":1,"position":{"x":4,"y":3,"direction":0}},{"type":1,"position":{"x":6,"y":3,"direction":0}},{"type":1,"position":{"x":7,"y":3,"direction":0}},{"type":1,"position":{"x":9,"y":3,"direction":0}},{"type":1,"position":{"x":10,"y":3,"direction":0}},{"type":1,"position":{"x":0,"y":6,"direction":0}},{"type":1,"position":{"x":1,"y":6,"direction":0}},{"type":1,"position":{"x":3,"y":6,"direction":0}},{"type":1,"position":{"x":4,"y":6,"direction":0}},{"type":1,"position":{"x":6,"y":6,"direction":0}},{"type":1,"position":{"x":7,"y":6,"direction":0}},{"type":1,"position":{"x":9,"y":6,"direction":0}},{"type":1,"position":{"x":10,"y":6,"direction":0}},{"type":1,"position":{"x":11,"y":6,"direction":3}},{"type":1,"position":{"x":11,"y":7,"direction":3}},{"type":1,"position":{"x":11,"y":3,"direction":3}},{"type":1,"position":{"x":11,"y":4,"direction":3}},{"type":1,"position":{"x":11,"y":0,"direction":3}},{"type":1,"position":{"x":11,"y":1,"direction":3}},{"type":1,"position":{"x":8,"y":0,"direction":3}},{"type":1,"position":{"x":8,"y":1,"direction":3}},{"type":1,"position":{"x":5,"y":0,"direction":3}},{"type":1,"position":{"x":5,"y":1,"direction":3}},{"type":1,"position":{"x":5,"y":3,"direction":3}},{"type":1,"position":{"x":5,"y":4,"direction":3}},{"type":1,"position":{"x":5,"y":6,"direction":3}},{"type":1,"position":{"x":5,"y":7,"direction":3}},{"type":1,"position":{"x":2,"y":6,"direction":3}},{"type":1,"position":{"x":2,"y":7,"direction":3}},{"type":1,"position":{"x":2,"y":3,"direction":3}},{"type":1,"position":{"x":2,"y":4,"direction":3}},{"type":1,"position":{"x":2,"y":0,"direction":3}},{"type":1,"position":{"x":2,"y":1,"direction":3}},{"type":1,"position":{"x":2,"y":2,"direction":2}},{"type":1,"position":{"x":1,"y":2,"direction":2}},{"type":1,"position":{"x":5,"y":2,"direction":2}},{"type":1,"position":{"x":4,"y":2,"direction":2}},{"type":1,"position":{"x":8,"y":2,"direction":2}},{"type":1,"position":{"x":7,"y":2,"direction":2}},{"type":1,"position":{"x":11,"y":2,"direction":2}},{"type":1,"position":{"x":10,"y":2,"direction":2}},{"type":1,"position":{"x":11,"y":5,"direction":2}},{"type":1,"position":{"x":10,"y":5,"direction":2}},{"type":1,"position":{"x":11,"y":8,"direction":2}},{"type":1,"position":{"x":10,"y":8,"direction":2}},{"type":1,"position":{"x":8,"y":8,"direction":2}},{"type":1,"position":{"x":7,"y":8,"direction":2}},{"type":1,"position":{"x":5,"y":8,"direction":2}},{"type":1,"position":{"x":4,"y":8,"direction":2}},{"type":1,"position":{"x":2,"y":8,"direction":2}},{"type":1,"position":{"x":1,"y":8,"direction":2}},{"type":1,"position":{"x":2,"y":5,"direction":2}},{"type":1,"position":{"x":1,"y":5,"direction":2}},{"type":1,"position":{"x":5,"y":5,"direction":2}},{"type":1,"position":{"x":4,"y":5,"direction":2}},{"type":1,"position":{"x":8,"y":5,"direction":2}},{"type":1,"position":{"x":7,"y":5,"direction":2}},{"type":1,"position":{"x":8,"y":3,"direction":3}},{"type":1,"position":{"x":8,"y":4,"direction":3}},{"type":1,"position":{"x":8,"y":6,"direction":3}},{"type":1,"position":{"x":8,"y":7,"direction":3}},{"type":1,"position":{"x":0,"y":2,"direction":1}},{"type":1,"position":{"x":0,"y":1,"direction":1}},{"type":1,"position":{"x":0,"y":5,"direction":1}},{"type":1,"position":{"x":0,"y":4,"direction":1}},{"type":1,"position":{"x":0,"y":8,"direction":1}},{"type":1,"position":{"x":0,"y":7,"direction":1}},{"type":1,"position":{"x":3,"y":8,"direction":1}},{"type":1,"position":{"x":3,"y":7,"direction":1}},{"type":1,"position":{"x":3,"y":5,"direction":1}},{"type":1,"position":{"x":3,"y":4,"direction":1}},{"type":1,"position":{"x":3,"y":2,"direction":1}},{"type":1,"position":{"x":3,"y":1,"direction":1}},{"type":1,"position":{"x":6,"y":2,"direction":1}},{"type":1,"position":{"x":6,"y":1,"direction":1}},{"type":1,"position":{"x":9,"y":2,"direction":1}},{"type":1,"position":{"x":9,"y":1,"direction":1}},{"type":1,"position":{"x":9,"y":5,"direction":1}},{"type":1,"position":{"x":9,"y":4,"direction":1}},{"type":1,"position":{"x":6,"y":5,"direction":1}},{"type":1,"position":{"x":6,"y":4,"direction":1}},{"type":1,"position":{"x":6,"y":8,"direction":1}},{"type":1,"position":{"x":6,"y":7,"direction":1}},{"type":1,"position":{"x":9,"y":8,"direction":1}},{"type":1,"position":{"x":9,"y":7,"direction":1}}]}'),
    NamedChallengeData(
        type: ChallengeType.RunAway,
        name: ' #2',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,2,1,0,0,0,2,1,0],[2,0,0,0,0,0,0,0,0],[2,0,0,2,0,1,0,0,2],[2,1,0,0,0,0,1,1,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,2],[2,1,0,0,0,0,2,0,0],[2,2,0,1,0,2,0,1,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,2,0,0,0,2],[2,1,0,0,0,1,0,0,0]]},"entities":[{"type":1,"position":{"x":0,"y":0,"direction":0}},{"type":1,"position":{"x":2,"y":0,"direction":0}},{"type":1,"position":{"x":1,"y":0,"direction":0}},{"type":1,"position":{"x":0,"y":8,"direction":1}},{"type":1,"position":{"x":0,"y":7,"direction":1}},{"type":1,"position":{"x":0,"y":6,"direction":1}},{"type":1,"position":{"x":1,"y":7,"direction":1}},{"type":1,"position":{"x":1,"y":2,"direction":1}},{"type":1,"position":{"x":8,"y":7,"direction":1}},{"type":1,"position":{"x":10,"y":5,"direction":3}},{"type":1,"position":{"x":11,"y":0,"direction":3}},{"type":1,"position":{"x":11,"y":1,"direction":3}},{"type":1,"position":{"x":11,"y":2,"direction":3}},{"type":1,"position":{"x":10,"y":1,"direction":3}},{"type":1,"position":{"x":3,"y":1,"direction":3}},{"type":1,"position":{"x":3,"y":6,"direction":3}},{"type":1,"position":{"x":11,"y":8,"direction":2}},{"type":1,"position":{"x":10,"y":8,"direction":2}},{"type":1,"position":{"x":9,"y":8,"direction":2}},{"type":1,"position":{"x":10,"y":7,"direction":2}},{"type":1,"position":{"x":10,"y":3,"direction":2}},{"type":1,"position":{"x":3,"y":2,"direction":2}},{"type":1,"position":{"x":3,"y":7,"direction":2}},{"type":1,"position":{"x":1,"y":6,"direction":0}},{"type":1,"position":{"x":1,"y":1,"direction":0}},{"type":1,"position":{"x":8,"y":1,"direction":0}},{"type":1,"position":{"x":8,"y":3,"direction":0}},{"type":1,"position":{"x":8,"y":5,"direction":0}},{"type":0,"position":{"x":3,"y":3,"direction":0}},{"type":0,"position":{"x":4,"y":1,"direction":0}},{"type":0,"position":{"x":6,"y":1,"direction":3}},{"type":0,"position":{"x":7,"y":3,"direction":3}},{"type":0,"position":{"x":7,"y":5,"direction":2}},{"type":0,"position":{"x":6,"y":7,"direction":2}},{"type":0,"position":{"x":4,"y":7,"direction":1}},{"type":0,"position":{"x":3,"y":5,"direction":1}}]}'),
    NamedChallengeData(
        type: ChallengeType.LunchTime,
        name: ' #2',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,3,1,1,1,1,1,1,1],[2,3,0,0,0,0,0,1,2],[2,3,3,0,0,0,1,2,0],[2,0,3,3,0,1,2,0,0],[2,0,0,3,3,2,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,2,2,0,0,0],[2,0,0,2,1,0,2,0,0],[2,0,2,1,0,1,0,2,0],[2,2,1,0,0,0,1,0,2],[2,1,0,0,0,0,0,1,0]]},"entities":[{"type":0,"position":{"x":5,"y":4,"direction":0}},{"type":1,"position":{"x":0,"y":0,"direction":0}},{"type":1,"position":{"x":1,"y":0,"direction":0}},{"type":1,"position":{"x":2,"y":1,"direction":0}},{"type":1,"position":{"x":3,"y":1,"direction":0}},{"type":1,"position":{"x":3,"y":2,"direction":0}},{"type":1,"position":{"x":4,"y":2,"direction":0}},{"type":1,"position":{"x":4,"y":3,"direction":0}},{"type":1,"position":{"x":5,"y":3,"direction":0}},{"type":1,"position":{"x":3,"y":3,"direction":3}},{"type":1,"position":{"x":3,"y":4,"direction":3}},{"type":1,"position":{"x":2,"y":2,"direction":3}},{"type":1,"position":{"x":2,"y":3,"direction":3}},{"type":1,"position":{"x":1,"y":1,"direction":3}},{"type":1,"position":{"x":1,"y":2,"direction":3}},{"type":1,"position":{"x":0,"y":1,"direction":3}},{"type":1,"position":{"x":0,"y":2,"direction":3}}]}'),
    NamedChallengeData(
        type: ChallengeType.OneHundredMice,
        name: ' #2',
        gameData:
            '{"board":{"tiles":[[{"type":3,"player":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":3,"player":0},{"type":3,"player":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":4,"direction":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":4,"direction":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":4,"direction":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":4,"direction":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":3,"player":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":3,"player":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,3,1,1],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,2,0,0],[3,1,1,1,1,1,3,0,1],[2,0,2,0,0,2,0,0,0],[2,0,0,3,2,0,0,0,0],[2,0,0,2,2,0,0,0,0],[2,0,2,1,0,2,0,0,0],[2,0,0,0,0,0,2,0,0],[3,1,1,1,1,1,3,0,1],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,2,0,0]]},"entities":[]}'),
    NamedChallengeData(
        type: ChallengeType.GetMice,
        name: ' #3',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":3,"player":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":2},{"type":3,"player":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":2},{"type":0}],[{"type":0},{"type":2},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0}],[{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":2},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,3,1,1,1,1],[2,2,0,0,0,0,0,1,2],[2,2,2,1,0,0,2,0,0],[2,0,0,1,0,0,1,0,2],[2,2,0,1,0,0,0,0,0],[2,0,0,0,0,0,0,0,1],[3,1,0,0,2,0,0,0,0],[2,1,2,0,0,0,0,1,0],[2,0,1,0,1,0,0,0,2],[2,0,0,2,1,0,0,2,2],[2,1,0,0,0,3,0,2,2],[2,1,0,0,2,0,0,0,0]]},"entities":[{"type":1,"position":{"x":3,"y":2,"direction":0}},{"type":1,"position":{"x":3,"y":3,"direction":0}},{"type":1,"position":{"x":6,"y":6,"direction":0}},{"type":1,"position":{"x":6,"y":5,"direction":0}},{"type":1,"position":{"x":7,"y":6,"direction":2}},{"type":1,"position":{"x":7,"y":5,"direction":2}},{"type":1,"position":{"x":4,"y":3,"direction":2}},{"type":1,"position":{"x":4,"y":2,"direction":2}},{"type":1,"position":{"x":5,"y":6,"direction":0}},{"type":1,"position":{"x":5,"y":5,"direction":0}},{"type":1,"position":{"x":5,"y":3,"direction":2}},{"type":1,"position":{"x":5,"y":2,"direction":2}},{"type":1,"position":{"x":4,"y":6,"direction":1}},{"type":1,"position":{"x":3,"y":6,"direction":1}},{"type":1,"position":{"x":6,"y":4,"direction":1}},{"type":1,"position":{"x":7,"y":4,"direction":1}},{"type":1,"position":{"x":6,"y":3,"direction":1}},{"type":1,"position":{"x":7,"y":3,"direction":1}},{"type":1,"position":{"x":6,"y":2,"direction":3}},{"type":1,"position":{"x":7,"y":2,"direction":3}},{"type":1,"position":{"x":3,"y":4,"direction":3}},{"type":1,"position":{"x":4,"y":4,"direction":3}},{"type":1,"position":{"x":3,"y":5,"direction":3}},{"type":1,"position":{"x":4,"y":5,"direction":3}}]}'),
    NamedChallengeData(
        type: ChallengeType.RunAway,
        name: ' #3',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":3,"player":0},{"type":0},{"type":3,"player":0},{"type":0},{"type":3,"player":0},{"type":0},{"type":3,"player":0},{"type":0},{"type":0}],[{"type":2},{"type":0},{"type":2},{"type":0},{"type":2},{"type":0},{"type":2},{"type":0},{"type":2}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,0,0,0,0,0,0,0,0],[3,0,0,0,0,0,0,0,1],[3,0,0,0,0,0,0,0,1],[2,0,0,0,0,0,0,0,0],[1,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,0,0,0],[2,2,2,2,2,2,2,2,2],[2,2,2,2,2,2,2,2,2],[2,2,2,2,2,2,2,2,2],[3,0,3,0,3,0,3,0,2],[2,0,2,0,2,0,2,0,2]]},"entities":[{"type":1,"position":{"x":0,"y":2,"direction":1}},{"type":1,"position":{"x":0,"y":3,"direction":1}},{"type":1,"position":{"x":0,"y":4,"direction":1}},{"type":1,"position":{"x":3,"y":2,"direction":1}},{"type":1,"position":{"x":3,"y":3,"direction":1}},{"type":1,"position":{"x":3,"y":4,"direction":1}},{"type":1,"position":{"x":2,"y":6,"direction":1}},{"type":1,"position":{"x":2,"y":7,"direction":1}},{"type":1,"position":{"x":2,"y":8,"direction":1}},{"type":1,"position":{"x":2,"y":0,"direction":3}},{"type":1,"position":{"x":2,"y":1,"direction":3}},{"type":1,"position":{"x":2,"y":2,"direction":3}},{"type":1,"position":{"x":1,"y":3,"direction":3}},{"type":1,"position":{"x":1,"y":4,"direction":3}},{"type":1,"position":{"x":1,"y":5,"direction":3}},{"type":1,"position":{"x":4,"y":3,"direction":3}},{"type":1,"position":{"x":4,"y":4,"direction":3}},{"type":1,"position":{"x":4,"y":5,"direction":3}},{"type":0,"position":{"x":6,"y":1,"direction":1}},{"type":0,"position":{"x":5,"y":7,"direction":1}},{"type":0,"position":{"x":5,"y":6,"direction":1}},{"type":0,"position":{"x":6,"y":6,"direction":1}},{"type":0,"position":{"x":6,"y":5,"direction":1}}]}'),
    NamedChallengeData(
        type: ChallengeType.LunchTime,
        name: ' #3',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,3,3,1,1,1],[2,3,1,2,0,0,3,1,2],[2,2,0,2,2,2,2,0,2],[2,2,0,2,2,2,2,0,2],[3,1,1,1,2,3,1,1,1],[3,1,2,3,0,1,1,0,3],[2,0,2,0,0,0,0,2,2],[3,1,0,1,2,3,1,0,1],[3,1,1,1,2,3,1,1,1],[3,1,1,2,2,1,1,1,0],[2,0,0,2,0,0,0,0,2],[3,1,1,0,2,3,1,1,0]]},"entities":[{"type":1,"position":{"x":0,"y":8,"direction":0}},{"type":1,"position":{"x":1,"y":8,"direction":0}},{"type":1,"position":{"x":2,"y":8,"direction":0}},{"type":1,"position":{"x":3,"y":8,"direction":0}},{"type":1,"position":{"x":8,"y":8,"direction":0}},{"type":1,"position":{"x":9,"y":8,"direction":0}},{"type":1,"position":{"x":10,"y":8,"direction":0}},{"type":1,"position":{"x":5,"y":7,"direction":0}},{"type":1,"position":{"x":6,"y":7,"direction":0}},{"type":1,"position":{"x":3,"y":0,"direction":2}},{"type":1,"position":{"x":2,"y":0,"direction":2}},{"type":1,"position":{"x":1,"y":0,"direction":2}},{"type":1,"position":{"x":0,"y":0,"direction":3}},{"type":1,"position":{"x":0,"y":1,"direction":3}},{"type":1,"position":{"x":0,"y":2,"direction":3}},{"type":1,"position":{"x":0,"y":3,"direction":0}},{"type":1,"position":{"x":1,"y":3,"direction":0}},{"type":1,"position":{"x":2,"y":3,"direction":0}},{"type":1,"position":{"x":3,"y":3,"direction":0}},{"type":1,"position":{"x":4,"y":0,"direction":3}},{"type":1,"position":{"x":4,"y":1,"direction":3}},{"type":1,"position":{"x":4,"y":2,"direction":3}},{"type":1,"position":{"x":4,"y":3,"direction":3}},{"type":1,"position":{"x":7,"y":0,"direction":3}},{"type":1,"position":{"x":7,"y":1,"direction":3}},{"type":1,"position":{"x":7,"y":2,"direction":3}},{"type":1,"position":{"x":7,"y":3,"direction":3}},{"type":1,"position":{"x":8,"y":0,"direction":3}},{"type":1,"position":{"x":8,"y":1,"direction":3}},{"type":1,"position":{"x":8,"y":2,"direction":3}},{"type":1,"position":{"x":8,"y":3,"direction":0}},{"type":1,"position":{"x":9,"y":3,"direction":0}},{"type":1,"position":{"x":10,"y":3,"direction":0}},{"type":1,"position":{"x":11,"y":3,"direction":1}},{"type":1,"position":{"x":11,"y":2,"direction":1}},{"type":1,"position":{"x":11,"y":1,"direction":1}},{"type":1,"position":{"x":11,"y":0,"direction":1}},{"type":1,"position":{"x":11,"y":7,"direction":1}},{"type":1,"position":{"x":11,"y":6,"direction":1}},{"type":1,"position":{"x":11,"y":5,"direction":1}},{"type":1,"position":{"x":11,"y":8,"direction":1}},{"type":1,"position":{"x":8,"y":5,"direction":3}},{"type":1,"position":{"x":8,"y":6,"direction":3}},{"type":1,"position":{"x":8,"y":7,"direction":3}},{"type":1,"position":{"x":7,"y":5,"direction":3}},{"type":1,"position":{"x":7,"y":6,"direction":3}},{"type":1,"position":{"x":7,"y":7,"direction":3}},{"type":1,"position":{"x":7,"y":8,"direction":3}},{"type":1,"position":{"x":4,"y":5,"direction":3}},{"type":1,"position":{"x":4,"y":6,"direction":3}},{"type":1,"position":{"x":4,"y":7,"direction":3}},{"type":1,"position":{"x":4,"y":8,"direction":3}},{"type":1,"position":{"x":0,"y":5,"direction":3}},{"type":1,"position":{"x":0,"y":6,"direction":3}},{"type":1,"position":{"x":0,"y":7,"direction":3}},{"type":1,"position":{"x":1,"y":5,"direction":2}},{"type":1,"position":{"x":2,"y":5,"direction":2}},{"type":1,"position":{"x":3,"y":5,"direction":2}},{"type":1,"position":{"x":5,"y":2,"direction":0}},{"type":1,"position":{"x":6,"y":2,"direction":0}},{"type":0,"position":{"x":0,"y":4,"direction":0}}]}'),
    NamedChallengeData(
        type: ChallengeType.OneHundredMice,
        name: ' #3',
        gameData:
            '{"board":{"tiles":[[{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":3,"player":0}],[{"type":4,"direction":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":4,"direction":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":4,"direction":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[2,0,0,2,2,2,2,2,2],[2,0,0,2,2,0,2,2,2],[2,0,0,2,0,2,2,0,2],[2,0,0,2,2,0,2,2,2],[2,0,0,2,2,2,2,0,2],[2,0,0,2,0,2,2,2,2],[2,0,0,2,2,2,0,2,2],[2,0,0,2,0,2,2,2,0],[2,0,0,2,2,0,2,0,2],[2,0,0,2,0,2,2,2,2],[2,0,0,0,2,2,0,2,2],[2,0,0,2,2,2,2,2,2]]},"entities":[]}'),
    NamedChallengeData(
        type: ChallengeType.GetMice,
        name: ' #4',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":3,"player":0},{"type":3,"player":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":3,"player":0},{"type":3,"player":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":2},{"type":2},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,1,1],[2,0,0,0,0,0,0,0,0],[2,3,1,3,1,3,1,3,1],[2,0,0,2,0,0,0,2,0],[2,1,0,2,1,1,0,2,0],[2,0,0,2,0,0,0,2,0],[2,0,0,2,0,2,0,2,0],[2,0,0,2,0,2,0,2,0],[2,0,0,2,0,2,0,2,0],[2,2,0,0,0,2,0,0,0],[2,1,1,1,1,1,1,3,1],[2,0,0,0,0,0,0,0,0]]},"entities":[{"type":1,"position":{"x":11,"y":0,"direction":2}},{"type":1,"position":{"x":9,"y":0,"direction":2}},{"type":1,"position":{"x":7,"y":0,"direction":2}},{"type":1,"position":{"x":5,"y":0,"direction":2}},{"type":1,"position":{"x":3,"y":0,"direction":2}},{"type":1,"position":{"x":11,"y":6,"direction":1}},{"type":1,"position":{"x":11,"y":4,"direction":1}},{"type":1,"position":{"x":11,"y":2,"direction":1}}]}'),
    NamedChallengeData(
        type: ChallengeType.RunAway,
        name: ' #4',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,3,1],[2,0,2,1,1,1,1,0,0],[3,1,0,0,2,1,0,3,1],[2,0,2,0,0,0,2,0,0],[3,1,0,2,1,0,0,3,1],[2,0,2,0,0,2,0,0,0],[3,1,0,1,2,1,0,3,1],[2,0,2,0,0,0,2,0,0],[3,1,0,2,1,0,0,3,1],[2,0,2,0,0,2,0,0,0],[3,1,0,1,2,1,0,3,1],[2,0,2,0,0,0,2,0,0]]},"entities":[{"type":1,"position":{"x":0,"y":7,"direction":0}},{"type":1,"position":{"x":2,"y":7,"direction":0}},{"type":1,"position":{"x":4,"y":7,"direction":0}},{"type":1,"position":{"x":6,"y":7,"direction":0}},{"type":1,"position":{"x":8,"y":7,"direction":0}},{"type":1,"position":{"x":10,"y":7,"direction":0}},{"type":1,"position":{"x":0,"y":0,"direction":0}},{"type":1,"position":{"x":2,"y":0,"direction":0}},{"type":1,"position":{"x":4,"y":0,"direction":0}},{"type":1,"position":{"x":6,"y":0,"direction":0}},{"type":1,"position":{"x":8,"y":0,"direction":0}},{"type":1,"position":{"x":10,"y":0,"direction":0}},{"type":1,"position":{"x":10,"y":4,"direction":0}},{"type":1,"position":{"x":8,"y":3,"direction":0}},{"type":1,"position":{"x":6,"y":4,"direction":0}},{"type":1,"position":{"x":4,"y":3,"direction":0}},{"type":1,"position":{"x":2,"y":4,"direction":0}},{"type":1,"position":{"x":3,"y":5,"direction":2}},{"type":1,"position":{"x":5,"y":4,"direction":2}},{"type":1,"position":{"x":7,"y":5,"direction":2}},{"type":1,"position":{"x":9,"y":4,"direction":2}},{"type":1,"position":{"x":11,"y":5,"direction":2}},{"type":1,"position":{"x":11,"y":1,"direction":2}},{"type":1,"position":{"x":9,"y":1,"direction":2}},{"type":1,"position":{"x":7,"y":1,"direction":2}},{"type":1,"position":{"x":5,"y":1,"direction":2}},{"type":1,"position":{"x":3,"y":1,"direction":2}},{"type":1,"position":{"x":1,"y":1,"direction":2}},{"type":1,"position":{"x":1,"y":8,"direction":2}},{"type":1,"position":{"x":3,"y":8,"direction":2}},{"type":1,"position":{"x":5,"y":8,"direction":2}},{"type":1,"position":{"x":7,"y":8,"direction":2}},{"type":1,"position":{"x":9,"y":8,"direction":2}},{"type":1,"position":{"x":11,"y":8,"direction":2}},{"type":0,"position":{"x":11,"y":6,"direction":2}}]}'),
    NamedChallengeData(
        type: ChallengeType.LunchTime,
        name: ' #4',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":2},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0}],[{"type":2},{"type":2},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":2},{"type":2},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":2},{"type":2},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,3,1,1,1,3,1,1],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,2,0,0],[2,0,0,0,0,0,3,0,1],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,2,0,0],[2,0,0,0,0,0,3,0,1],[2,0,0,0,0,0,0,0,0],[2,0,2,0,0,0,2,0,0],[3,1,0,3,0,1,3,0,1],[2,0,0,0,0,0,0,0,0],[2,0,0,2,0,0,2,0,0]]},"entities":[{"type":1,"position":{"x":0,"y":6,"direction":0}},{"type":1,"position":{"x":1,"y":6,"direction":0}},{"type":1,"position":{"x":3,"y":6,"direction":0}},{"type":1,"position":{"x":4,"y":6,"direction":0}},{"type":1,"position":{"x":6,"y":6,"direction":0}},{"type":1,"position":{"x":7,"y":6,"direction":0}},{"type":1,"position":{"x":9,"y":6,"direction":0}},{"type":1,"position":{"x":10,"y":6,"direction":0}},{"type":1,"position":{"x":9,"y":3,"direction":0}},{"type":1,"position":{"x":10,"y":3,"direction":0}},{"type":1,"position":{"x":0,"y":8,"direction":1}},{"type":1,"position":{"x":0,"y":7,"direction":1}},{"type":1,"position":{"x":3,"y":8,"direction":1}},{"type":1,"position":{"x":3,"y":7,"direction":1}},{"type":1,"position":{"x":6,"y":8,"direction":1}},{"type":1,"position":{"x":6,"y":7,"direction":1}},{"type":1,"position":{"x":9,"y":8,"direction":1}},{"type":1,"position":{"x":9,"y":7,"direction":1}},{"type":1,"position":{"x":9,"y":5,"direction":1}},{"type":1,"position":{"x":9,"y":4,"direction":1}},{"type":1,"position":{"x":11,"y":4,"direction":3}},{"type":1,"position":{"x":11,"y":3,"direction":3}},{"type":1,"position":{"x":11,"y":6,"direction":3}},{"type":1,"position":{"x":11,"y":7,"direction":3}},{"type":1,"position":{"x":8,"y":6,"direction":3}},{"type":1,"position":{"x":8,"y":7,"direction":3}},{"type":1,"position":{"x":5,"y":6,"direction":3}},{"type":1,"position":{"x":5,"y":7,"direction":3}},{"type":1,"position":{"x":2,"y":6,"direction":3}},{"type":1,"position":{"x":2,"y":7,"direction":3}},{"type":1,"position":{"x":2,"y":8,"direction":2}},{"type":1,"position":{"x":1,"y":8,"direction":2}},{"type":1,"position":{"x":5,"y":8,"direction":2}},{"type":1,"position":{"x":4,"y":8,"direction":2}},{"type":1,"position":{"x":8,"y":8,"direction":2}},{"type":1,"position":{"x":7,"y":8,"direction":2}},{"type":1,"position":{"x":11,"y":8,"direction":2}},{"type":1,"position":{"x":10,"y":8,"direction":2}},{"type":1,"position":{"x":11,"y":5,"direction":2}},{"type":1,"position":{"x":10,"y":5,"direction":2}},{"type":0,"position":{"x":0,"y":1,"direction":0}}]}'),
    NamedChallengeData(
        type: ChallengeType.OneHundredMice,
        name: ' #4',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":4,"direction":1},{"type":4,"direction":2},{"type":0},{"type":0},{"type":0},{"type":3,"player":0},{"type":3,"player":0},{"type":0}],[{"type":0},{"type":4,"direction":0},{"type":4,"direction":3},{"type":0},{"type":0},{"type":0},{"type":3,"player":0},{"type":3,"player":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,0,1,2,3,1,1,1],[2,0,0,0,2,2,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,2,2,0,0,0],[3,0,1,1,3,3,0,1,1],[2,0,0,0,2,2,0,0,0],[2,0,0,0,2,2,0,0,0],[2,0,0,0,2,2,0,0,0],[3,0,1,1,2,3,1,0,1],[2,0,0,0,2,2,0,0,0],[2,0,0,0,2,0,0,0,0],[2,0,0,0,2,2,0,0,0]]},"entities":[]}'),
    NamedChallengeData(
        type: ChallengeType.GetMice,
        name: ' #5',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0}],[{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":2},{"type":2},{"type":2},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,1,1,1,1,1,3,1],[2,0,0,0,0,0,0,0,0],[3,1,1,1,1,1,1,1,0],[2,0,0,0,0,0,0,0,0],[2,1,1,1,1,1,1,3,1],[2,0,0,0,0,0,0,0,0],[3,3,1,1,1,1,1,1,0],[2,0,0,2,0,0,0,0,0],[2,1,1,1,1,1,1,3,1],[2,0,0,0,0,0,0,0,0],[3,1,1,1,1,1,1,1,0],[2,0,0,0,2,0,0,0,0]]},"entities":[{"type":1,"position":{"x":8,"y":7,"direction":0}},{"type":1,"position":{"x":10,"y":0,"direction":0}},{"type":1,"position":{"x":11,"y":3,"direction":2}},{"type":1,"position":{"x":9,"y":8,"direction":2}},{"type":1,"position":{"x":11,"y":0,"direction":3}},{"type":1,"position":{"x":11,"y":1,"direction":3}},{"type":1,"position":{"x":11,"y":2,"direction":3}},{"type":1,"position":{"x":9,"y":7,"direction":3}},{"type":1,"position":{"x":8,"y":8,"direction":1}},{"type":1,"position":{"x":10,"y":3,"direction":1}},{"type":1,"position":{"x":10,"y":2,"direction":1}},{"type":1,"position":{"x":10,"y":1,"direction":1}}]}'),
    NamedChallengeData(
        type: ChallengeType.RunAway,
        name: ' #5',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":3,"player":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,3,1,1,1,1,1,1,1],[2,0,0,0,0,0,0,3,2],[2,0,0,2,0,1,1,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,2,0,0,0,0,2,0],[2,0,2,0,0,0,0,2,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,2,2,0],[2,2,3,1,0,0,0,0,0],[2,1,0,0,0,0,0,0,2]]},"entities":[{"type":1,"position":{"x":1,"y":7,"direction":0}},{"type":1,"position":{"x":2,"y":7,"direction":0}},{"type":1,"position":{"x":3,"y":7,"direction":0}},{"type":1,"position":{"x":5,"y":7,"direction":0}},{"type":1,"position":{"x":4,"y":7,"direction":0}},{"type":1,"position":{"x":7,"y":8,"direction":2}},{"type":1,"position":{"x":8,"y":8,"direction":2}},{"type":1,"position":{"x":9,"y":8,"direction":2}},{"type":1,"position":{"x":10,"y":8,"direction":2}},{"type":1,"position":{"x":11,"y":8,"direction":2}},{"type":0,"position":{"x":9,"y":6,"direction":2}},{"type":0,"position":{"x":8,"y":6,"direction":2}},{"type":0,"position":{"x":5,"y":6,"direction":2}},{"type":0,"position":{"x":2,"y":2,"direction":0}},{"type":0,"position":{"x":3,"y":2,"direction":0}},{"type":0,"position":{"x":6,"y":2,"direction":0}}]}'),
    NamedChallengeData(
        type: ChallengeType.LunchTime,
        name: ' #5',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0}],[{"type":0},{"type":2},{"type":2},{"type":2},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,3,1,1,1,1,3,1],[2,0,0,0,0,0,2,0,0],[2,0,2,0,2,0,0,2,0],[3,0,1,1,1,1,1,3,1],[2,0,0,0,2,0,0,0,0],[2,0,0,0,0,0,0,2,0],[3,1,3,1,1,1,1,1,0],[2,0,0,0,0,0,0,0,0],[2,0,2,0,0,0,0,2,0],[2,3,1,3,1,3,1,3,1],[2,0,2,0,2,0,0,0,0],[2,2,2,0,0,0,0,2,0]]},"entities":[{"type":1,"position":{"x":3,"y":7,"direction":0}},{"type":1,"position":{"x":4,"y":7,"direction":0}},{"type":1,"position":{"x":0,"y":7,"direction":0}},{"type":1,"position":{"x":1,"y":7,"direction":0}},{"type":1,"position":{"x":0,"y":0,"direction":0}},{"type":1,"position":{"x":1,"y":0,"direction":0}},{"type":1,"position":{"x":6,"y":0,"direction":0}},{"type":1,"position":{"x":7,"y":0,"direction":0}},{"type":1,"position":{"x":5,"y":8,"direction":2}},{"type":1,"position":{"x":4,"y":8,"direction":2}},{"type":1,"position":{"x":2,"y":8,"direction":2}},{"type":1,"position":{"x":1,"y":8,"direction":2}},{"type":1,"position":{"x":2,"y":1,"direction":2}},{"type":1,"position":{"x":1,"y":1,"direction":2}},{"type":1,"position":{"x":8,"y":1,"direction":2}},{"type":1,"position":{"x":7,"y":1,"direction":2}},{"type":1,"position":{"x":6,"y":1,"direction":1}},{"type":1,"position":{"x":0,"y":1,"direction":1}},{"type":1,"position":{"x":0,"y":8,"direction":1}},{"type":1,"position":{"x":3,"y":8,"direction":1}},{"type":1,"position":{"x":5,"y":7,"direction":3}},{"type":1,"position":{"x":2,"y":7,"direction":3}},{"type":1,"position":{"x":2,"y":0,"direction":3}},{"type":1,"position":{"x":8,"y":0,"direction":3}},{"type":0,"position":{"x":11,"y":8,"direction":2}}]}'),
    NamedChallengeData(
        type: ChallengeType.OneHundredMice,
        name: ' #5',
        gameData:
            '{"board":{"tiles":[[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":3,"player":0},{"type":3,"player":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":3,"player":0},{"type":3,"player":0},{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0}],[{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0}],[{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":4,"direction":3},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2}],[{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":4,"direction":3},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0}],[{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":4,"direction":3},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}],[{"type":2},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":2},{"type":0}],[{"type":4,"direction":3},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0},{"type":0}]],"walls":[[3,1,3,1,1,1,0,2,2],[2,0,0,0,0,0,2,0,0],[2,0,0,0,0,0,0,2,2],[2,0,0,0,0,0,2,2,0],[3,1,1,1,1,1,2,0,2],[2,0,2,0,0,1,0,2,2],[3,1,1,1,1,1,2,0,0],[2,0,2,0,0,1,0,2,2],[3,1,1,1,1,1,2,0,2],[2,0,2,0,0,1,0,2,0],[3,1,1,1,1,1,2,2,2],[2,0,2,0,0,1,0,0,2]]},"entities":[]}'),
  ];

  static Map<String, int> slugs = challenges.asMap().map((index, value) =>
      MapEntry(Slugify(value.type.toPrettyString() + value.name), index));

  @override
  _OriginalChallengesState createState() => _OriginalChallengesState();
}

NamedChallengeData _buildChallengeData(BuildContext context, int i) {
  return NamedChallengeData.fromChallengeData(
      challengeData: OriginalChallenges.challenges[i].challengeData,
      name: OriginalChallenges.challenges[i].challengeData.type
              .toLocalizedString(context) +
          OriginalChallenges.challenges[i].name);
}

class _OriginalChallengesState extends State<OriginalChallenges>
    with AutomaticKeepAliveClientMixin<OriginalChallenges> {
  bool _showCompleted = false;
  SplayTreeSet<int> _cleared = SplayTreeSet();
  List<Duration> _times =
      List.filled(OriginalChallenges.challenges.length, Duration.zero);

  @override
  void initState() {
    super.initState();

    ChallengeProgressionManager.getTimes().then((List<Duration> times) {
      _cleared = SplayTreeSet<int>.from(Map.fromEntries(times
          .asMap()
          .entries
          .where((MapEntry<int, Duration> entry) =>
              entry.value.inMilliseconds > 0)).keys);

      setState(() {
        _times = times;
      });
    });
  }

  @override
  bool get wantKeepAlive => true;

  void _handleChallengeWin(int i, Duration time) {
    if (_times[i].inMilliseconds == 0 || time < _times[i]) {
      setState(() {
        _times[i] = time;
        _cleared.add(i);
      });

      ChallengeProgressionManager.setTime(i, time);
    }
  }

  void _openChallenge(int i) {
    if (OriginalChallenges.challenges.length > i + 1) {
      Navigator.of(context)
          .push(MaterialPageRoute<OverlayResult>(
              builder: (context) => Challenge(
                    hasNext: i != OriginalChallenges.challenges.length - 1,
                    challenge: _buildChallengeData(context, i),
                    onWin: (Duration time) => _handleChallengeWin(i, time),
                    bestTime: _times[i],
                  )))
          .then((OverlayResult? overlayResult) {
        if (overlayResult != null) {
          if (overlayResult == OverlayResult.PlayNext) {
            _openChallenge(i + 1);
          } else if (overlayResult == OverlayResult.PlayAgain) {
            _openChallenge(i);
          }
        } else {
          Router.of(context)
              .routeInformationProvider!
              .routerReportsNewRouteInformation(
                  RouteInformation(location: '/${PageKind.Challenge.slug}'));
        }
      });
    }
    Router.of(context)
        .routeInformationProvider!
        .routerReportsNewRouteInformation(RouteInformation(
            location:
                '/${PageKind.Challenge.slug}/${TabKind.Original.slug}/${Slugify(OriginalChallenges.challenges[i].challengeData.type.toPrettyString() + OriginalChallenges.challenges[i].name)}'));
  }

  Widget _buildChallengeTile(int i) {
    return ListTile(
      title: Text(OriginalChallenges.challenges[i].challengeData.type
              .toLocalizedString(context) +
          OriginalChallenges.challenges[i].name),
      subtitle: Text(OriginalChallenges.challenges[i].challengeData.type
          .toLocalizedString(context)),
      trailing: Visibility(
        visible: _cleared.contains(i),
        child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text(
              '${_times[i].inSeconds}.${_times[i].inMilliseconds % 1000 ~/ 10}s'),
          Icon(
            Icons.check,
            color: Colors.green,
          )
        ]),
      ),
      onTap: () {
        _openChallenge(i);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    List<int> challengeIndices =
        Iterable<int>.generate(OriginalChallenges.challenges.length)
            .toList(growable: false);

    if (!_showCompleted) {
      challengeIndices = SplayTreeSet<int>.from(challengeIndices)
          .difference(_cleared)
          .toList(growable: false);
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              if (orientation == Orientation.landscape ||
                  MediaQuery.of(context).size.width >= 270 * 2.5)
                return _buildLandscape(context, challengeIndices);
              else
                return _buildPortrait(challengeIndices);
            },
          ),
        ),
        CompletionIndicator(
          completedRatio:
              _cleared.length / OriginalChallenges.challenges.length,
          showCompleted: _showCompleted,
          onChanged: (bool? value) {
            if (value != null) {
              setState(() {
                _showCompleted = value;
              });
            }
          },
        )
      ],
    );
  }

  Widget _buildPortrait(List<int> challengeIndices) {
    return ListView.builder(
        itemCount: challengeIndices.length,
        itemBuilder: (context, i) => _buildChallengeTile(challengeIndices[i]));
  }

  Widget _buildLandscape(BuildContext context, List<int> challengeIndices) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 270,
        ),
        itemCount: challengeIndices.length,
        itemBuilder: (context, i) => _buildChallengeCard(challengeIndices[i]));
  }

  Widget _buildChallengeCard(int i) {
    return InkWell(
      key: ValueKey(i),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AspectRatio(
                  aspectRatio: 12 / 9,
                  child: Stack(
                    children: [
                      StaticGameView(
                        game: OriginalChallenges.challenges[i].challengeData
                            .getGame(),
                      ),
                      Visibility(
                        visible: _cleared.contains(i),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 150,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
            Text(
              OriginalChallenges.challenges[i].challengeData.type
                      .toLocalizedString(context) +
                  OriginalChallenges.challenges[i].name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      onTap: () {
        _openChallenge(i);
      },
    );
  }
}
