import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/tutorial/tabs/challenge.dart';
import 'package:nyanya_rocket/screens/tutorial/tabs/general.dart';
import 'package:nyanya_rocket/screens/tutorial/tabs/puzzle.dart';
import 'package:nyanya_rocket/widgets/bar_rail_tabs.dart';

class Tutorial extends StatelessWidget {
  const Tutorial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarRailTabs(
        title: NyaNyaLocalizations.of(context).tutorialTitle,
        tabs: [
          BarRailTab(
              content: const General(),
              label: NyaNyaLocalizations.of(context).generalLabel,
              icon: const FaIcon(FontAwesomeIcons.play)),
          BarRailTab(
              content: const Puzzle(),
              label: NyaNyaLocalizations.of(context).puzzleType,
              icon: const FaIcon(FontAwesomeIcons.puzzlePiece)),
          BarRailTab(
              content: const Challenge(),
              label: NyaNyaLocalizations.of(context).challengeType,
              icon: const FaIcon(FontAwesomeIcons.stopwatch)),
        ]);
  }
}
