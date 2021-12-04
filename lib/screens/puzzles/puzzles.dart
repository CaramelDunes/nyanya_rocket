import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../localization/nyanya_localizations.dart';
import '../../routing/nyanya_route_path.dart';
import '../../widgets/bar_rail_tabs.dart';
import 'widgets/community_puzzles.dart';
import 'widgets/local_puzzles.dart';
import 'widgets/original_puzzles.dart';

class Puzzles extends StatelessWidget {
  final TabKind initialTab;

  const Puzzles({Key? key, required this.initialTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localized = NyaNyaLocalizations.of(context);

    return BarRailTabs(
        initialTab: initialTab.index,
        title: localized.puzzlesTitle,
        tabs: [
          BarRailTab(
            content: const OriginalPuzzles(),
            icon: const FaIcon(FontAwesomeIcons.puzzlePiece),
            label: localized.originalTab,
            route: const NyaNyaRoutePath.originalPuzzles(),
          ),
          BarRailTab(
            content: const CommunityPuzzles(),
            icon: const FaIcon(FontAwesomeIcons.globe),
            label: localized.communityTab,
            route: const NyaNyaRoutePath.communityPuzzles(),
          ),
          BarRailTab(
            content: const LocalPuzzles(),
            icon: const FaIcon(FontAwesomeIcons.mobileAlt),
            label: localized.deviceTab,
            route: const NyaNyaRoutePath.localPuzzles(),
          )
        ]);
  }
}
