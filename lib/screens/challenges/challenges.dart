import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/challenges/tabs/community_challenges.dart';
import 'package:nyanya_rocket/screens/challenges/tabs/local_challenges.dart';
import 'package:nyanya_rocket/screens/challenges/tabs/original_challenges.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

class Challenges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text(NyaNyaLocalizations.of(context).challengesTitle),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.stopwatch),
                  text: NyaNyaLocalizations.of(context).originalTab,
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.globe),
                  text: NyaNyaLocalizations.of(context).communityTab,
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.mobileAlt),
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
