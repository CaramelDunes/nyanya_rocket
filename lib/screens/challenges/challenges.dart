import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../localization/nyanya_localizations.dart';
import '../../routing/nyanya_route_path.dart';
import '../../widgets/bar_rail_tabs.dart';
import 'tabs/community_challenges.dart';
import 'tabs/local_challenges.dart';
import 'tabs/original_challenges.dart';

class Challenges extends StatelessWidget {
  final TabKind initialTab;

  const Challenges({Key? key, required this.initialTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localized = NyaNyaLocalizations.of(context);

    return BarRailTabs(
        initialTab: initialTab.index,
        title: NyaNyaLocalizations.of(context).challengesTitle,
        tabs: [
          BarRailTab(
            content: const OriginalChallenges(),
            icon: const FaIcon(FontAwesomeIcons.stopwatch),
            label: localized.originalTab,
            route: const NyaNyaRoutePath.originalChallenges(),
          ),
          BarRailTab(
            content: const CommunityChallenges(),
            icon: const FaIcon(FontAwesomeIcons.globe),
            label: localized.communityTab,
            route: const NyaNyaRoutePath.communityChallenges(),
          ),
          BarRailTab(
            content: const LocalChallenges(),
            icon: const FaIcon(FontAwesomeIcons.mobileAlt),
            label: localized.deviceTab,
            route: const NyaNyaRoutePath.localChallenges(),
          )
        ]);
  }
}
