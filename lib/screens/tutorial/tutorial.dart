import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/tutorial/tabs/challenge.dart';
import 'package:nyanya_rocket/screens/tutorial/tabs/general.dart';
import 'package:nyanya_rocket/screens/tutorial/tabs/multiplayer.dart';
import 'package:nyanya_rocket/screens/tutorial/tabs/puzzle.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

class Tutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
            title: Text(NyaNyaLocalizations.of(context).tutorialTitle),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.play),
                  text: 'General',
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.puzzlePiece),
                  text: NyaNyaLocalizations.of(context).puzzleType,
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.stopwatch),
                  text: NyaNyaLocalizations.of(context).challengeType,
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.gamepad),
                  text: NyaNyaLocalizations.of(context).multiplayerType,
                ),
              ],
            )),
        drawer: DefaultDrawer(),
        body: TabBarView(
          children: [General(), Puzzle(), Challenge(), Multiplayer()],
        ),
      ),
    );
  }
}
