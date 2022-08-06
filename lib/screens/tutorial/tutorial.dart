import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../localization/nyanya_localizations.dart';
import '../../widgets/navigation/bar_rail_tabs.dart';
import 'tabs/challenge.dart';
import 'tabs/general.dart';
import 'tabs/puzzle.dart';

class Tutorial extends StatelessWidget {
  const Tutorial({super.key});

  @override
  Widget build(BuildContext context) {
    final localized = NyaNyaLocalizations.of(context);

    return BarRailTabs(title: localized.tutorialTitle, tabs: [
      BarRailTab(
          content: const General(),
          label: localized.generalLabel,
          icon: const FaIcon(FontAwesomeIcons.play)),
      BarRailTab(
          content: const Puzzle(),
          label: localized.puzzleType,
          icon: const FaIcon(FontAwesomeIcons.puzzlePiece)),
      BarRailTab(
          content: const Challenge(),
          label: localized.challengeType,
          icon: const FaIcon(FontAwesomeIcons.stopwatch)),
    ]);
  }
}
