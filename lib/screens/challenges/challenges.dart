import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/screens/challenges/tabs/community_challenges.dart';
import 'package:nyanya_rocket/screens/challenges/tabs/local_challenges.dart';
import 'package:nyanya_rocket/screens/challenges/tabs/original_challenges.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

class Challenges extends StatelessWidget {
  final TabKind initialTab;

  const Challenges({Key? key, this.initialTab = TabKind.Original})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool displayIcons =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return DefaultTabController(
      length: 3,
      initialIndex: initialTab.index,
      child: Scaffold(
        appBar: AppBar(
            title: Text(NyaNyaLocalizations.of(context).challengesTitle),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon:
                      displayIcons ? FaIcon(FontAwesomeIcons.stopwatch) : null,
                  text: NyaNyaLocalizations.of(context).originalTab,
                ),
                Tab(
                  icon: displayIcons ? FaIcon(FontAwesomeIcons.globe) : null,
                  text: NyaNyaLocalizations.of(context).communityTab,
                ),
                Tab(
                  icon:
                      displayIcons ? FaIcon(FontAwesomeIcons.mobileAlt) : null,
                  text: NyaNyaLocalizations.of(context).deviceTab,
                ),
              ],
            )),
        drawer: DefaultDrawer(),
        body: TabBarView(
          children: [
            OriginalChallenges(),
            CommunityChallenges(),
            LocalChallenges()
          ],
        ),
      ),
    );
  }
}
