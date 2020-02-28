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
    final bool displayIcons =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text(NyaNyaLocalizations.of(context).puzzlesTitle),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: displayIcons
                      ? FaIcon(FontAwesomeIcons.puzzlePiece)
                      : null,
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
          children: [OriginalPuzzles(), CommunityPuzzles(), LocalPuzzles()],
        ),
      ),
    );
  }
}
