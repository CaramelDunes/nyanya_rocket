import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';

import '../../widgets/bar_rail_tabs.dart';
import 'widgets/community_puzzles.dart';
import 'widgets/local_puzzles.dart';
import 'widgets/original_puzzles.dart';

class Puzzles extends StatelessWidget {
  final TabKind initialTab;

  const Puzzles({Key? key, this.initialTab = TabKind.original})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarRailTabs(
        initialTab: initialTab.index,
        title: NyaNyaLocalizations.of(context).puzzlesTitle,
        tabs: [
          BarRailTab(
            content: const OriginalPuzzles(),
            icon: const FaIcon(FontAwesomeIcons.puzzlePiece),
            label: NyaNyaLocalizations.of(context).originalTab,
          ),
          BarRailTab(
            content: const CommunityPuzzles(),
            icon: const FaIcon(FontAwesomeIcons.globe),
            label: NyaNyaLocalizations.of(context).communityTab,
          ),
          BarRailTab(
            content: const LocalPuzzles(),
            icon: const FaIcon(FontAwesomeIcons.mobileAlt),
            label: NyaNyaLocalizations.of(context).deviceTab,
          )
        ]);
  }
}
