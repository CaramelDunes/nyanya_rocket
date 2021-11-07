import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/screens/puzzles/widgets/community_puzzles.dart';
import 'package:nyanya_rocket/screens/puzzles/widgets/local_puzzles.dart';
import 'package:nyanya_rocket/screens/puzzles/widgets/original_puzzles.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

class Puzzles extends StatelessWidget {
  final TabKind initialTab;

  const Puzzles({Key? key, this.initialTab = TabKind.original})
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
            title: Text(NyaNyaLocalizations.of(context).puzzlesTitle),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: displayIcons
                      ? const FaIcon(FontAwesomeIcons.puzzlePiece)
                      : null,
                  text: NyaNyaLocalizations.of(context).originalTab,
                ),
                Tab(
                  icon: displayIcons
                      ? const FaIcon(FontAwesomeIcons.globe)
                      : null,
                  text: NyaNyaLocalizations.of(context).communityTab,
                ),
                Tab(
                  icon: displayIcons
                      ? const FaIcon(FontAwesomeIcons.mobileAlt)
                      : null,
                  text: NyaNyaLocalizations.of(context).deviceTab,
                ),
              ],
            )),
        drawer: const DefaultDrawer(),
        body: const TabBarView(
          children: [OriginalPuzzles(), CommunityPuzzles(), LocalPuzzles()],
        ),
      ),
    );
  }
}
