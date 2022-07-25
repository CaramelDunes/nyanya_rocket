import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/multiplayer/picker_tabs/community_boards.dart';
import 'package:nyanya_rocket/screens/multiplayer/picker_tabs/local_boards.dart';
import 'package:nyanya_rocket/screens/multiplayer/picker_tabs/original_boards.dart';

class BoardPickerLists extends StatelessWidget {
  const BoardPickerLists({Key? key}) : super(key: key);

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
                  icon: const FaIcon(FontAwesomeIcons.gamepad),
                  text: NyaNyaLocalizations.of(context).originalTab,
                ),
                Tab(
                  icon: const FaIcon(FontAwesomeIcons.globe),
                  text: NyaNyaLocalizations.of(context).communityTab,
                ),
                Tab(
                  icon: const FaIcon(FontAwesomeIcons.mobileScreenButton),
                  text: NyaNyaLocalizations.of(context).deviceTab,
                ),
              ],
            )),
        body: const TabBarView(
          children: [OriginalBoards(), CommunityBoards(), LocalBoards()],
        ),
      ),
    );
  }
}
