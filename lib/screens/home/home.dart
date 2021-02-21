import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/home/tabs/contributing.dart';
import 'package:nyanya_rocket/screens/home/tabs/whats_new.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final bool displayIcons =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: Text(NyaNyaLocalizations.of(context).homeTitle),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon:
                      displayIcons ? FaIcon(FontAwesomeIcons.newspaper) : null,
                  text: NyaNyaLocalizations.of(context).whatsNewTab,
                ),
                Tab(
                  icon: displayIcons
                      ? FaIcon(FontAwesomeIcons.handsHelping)
                      : null,
                  text: NyaNyaLocalizations.of(context).contributingTab,
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
