import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../localization/nyanya_localizations.dart';
import '../../routing/nyanya_route_path.dart';
import '../../widgets/navigation/bar_rail_tabs.dart';
import 'widgets/community_puzzles.dart';
import 'widgets/local_puzzles.dart';
import 'widgets/original_puzzles.dart';

class Puzzles extends StatelessWidget {
  final TabKind initialTab;

  const Puzzles({super.key, required this.initialTab});

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
            icon: const FaIcon(FontAwesomeIcons.mobileScreenButton),
            label: localized.deviceTab,
            route: const NyaNyaRoutePath.localPuzzles(),
          )
        ]);
  }
}
