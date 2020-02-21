import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/puzzles/widgets/community_puzzles.dart';
import 'package:nyanya_rocket/screens/puzzles/widgets/local_puzzles.dart';
import 'package:nyanya_rocket/screens/puzzles/widgets/original_puzzles.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

class Puzzles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text(NyaNyaLocalizations.of(context).puzzlesTitle),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: FaIcon(FontAwesomeIcons.puzzlePiece),
                  text: NyaNyaLocalizations.of(context).originalTab,
                ),
                Tab(
                  icon: FaIcon(FontAwesomeIcons.globe),
                  text: NyaNyaLocalizations.of(context).communityTab,
                ),
                Tab(
                  icon: FaIcon(FontAwesomeIcons.mobileAlt),
                  text: NyaNyaLocalizations.of(context).deviceTab,
                ),
              ],
            )),
        drawer: DefaultDrawer(),
        body: TabBarView(
          children: [OriginalPuzzles(), CommunityPuzzles(), LocalPuzzles()],
        ),
      ),
    );
  }
}
