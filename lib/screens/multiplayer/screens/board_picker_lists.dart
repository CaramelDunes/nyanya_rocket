import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/multiplayer/picker_tabs/community_boards.dart';
import 'package:nyanya_rocket/screens/multiplayer/picker_tabs/local_boards.dart';
import 'package:nyanya_rocket/screens/multiplayer/picker_tabs/original_boards.dart';

class BoardPickerLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text(NyaNyaLocalizations.of(context).multiplayerTitle),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: FaIcon(FontAwesomeIcons.gamepad),
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
        body: TabBarView(
          children: [OriginalBoards(), CommunityBoards(), LocalBoards()],
        ),
      ),
    );
  }
}
