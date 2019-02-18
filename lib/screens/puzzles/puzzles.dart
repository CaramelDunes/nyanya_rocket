import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/screens/puzzles/widgets/community_puzzles.dart';
import 'package:nyanya_rocket/screens/puzzles/widgets/local_puzzles.dart';
import 'package:nyanya_rocket/screens/puzzles/widgets/official_puzzles.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

class Puzzles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text('Puzzles'),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.puzzlePiece),
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
          children: [OfficialPuzzles(), CommunityPuzzles(), LocalPuzzles()],
        ),
      ),
    );
  }
}
