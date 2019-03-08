import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/screens/home/tabs/contributing.dart';
import 'package:nyanya_rocket/screens/home/tabs/whats_new.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text('Home'),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.newspaper),
                  text: 'What\'s new?',
                ),
                Tab(
                  icon: Icon(FontAwesomeIcons.handsHelping),
                  text: 'Contributing',
                ),
              ],
            )),
        drawer: DefaultDrawer(),
        body: TabBarView(
          children: [WhatsNew(), Contributing()],
        ),
      ),
    );
  }
}
