import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            title: Text('Challenges'),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.stopwatch),
                  text: 'Original',
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.globe),
                  text: 'Community',
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.mobileAlt),
                  text: 'Device',
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
