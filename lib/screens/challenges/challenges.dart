import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';

import '../../widgets/bar_rail_tabs.dart';
import 'tabs/community_challenges.dart';
import 'tabs/local_challenges.dart';
import 'tabs/original_challenges.dart';

class Challenges extends StatelessWidget {
  final TabKind initialTab;

  const Challenges({Key? key, this.initialTab = TabKind.original})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarRailTabs(
        initialTab: initialTab.index,
        title: NyaNyaLocalizations.of(context).puzzlesTitle,
        tabs: [
          BarRailTab(
            content: const OriginalChallenges(),
            icon: const FaIcon(FontAwesomeIcons.stopwatch),
            label: NyaNyaLocalizations.of(context).originalTab,
          ),
          BarRailTab(
            content: const CommunityChallenges(),
            icon: const FaIcon(FontAwesomeIcons.globe),
            label: NyaNyaLocalizations.of(context).communityTab,
          ),
          BarRailTab(
            content: const LocalChallenges(),
            icon: const FaIcon(FontAwesomeIcons.mobileAlt),
            label: NyaNyaLocalizations.of(context).deviceTab,
          )
        ]);
  }
}
