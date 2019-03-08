import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/screens/tutorial/tabs/challenge.dart';
import 'package:nyanya_rocket/screens/tutorial/tabs/general.dart';
import 'package:nyanya_rocket/screens/tutorial/tabs/puzzle.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

class Tutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text('How to play'),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.play),
                  text: 'General',
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.puzzlePiece),
                  text: 'Puzzle',
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.stopwatch),
                  text: 'Challenge',
                ),
              ],
            )),
        drawer: DefaultDrawer(),
        body: TabBarView(
          children: [General(), Puzzle(), Challenge()],
        ),
      ),
    );
  }
}
