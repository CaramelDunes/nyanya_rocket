import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/multiplayer_store.dart';
import 'package:nyanya_rocket/screens/multiplayer/widgets/device_multiplayer_setup.dart';
import 'package:nyanya_rocket/screens/multiplayer/widgets/lan_multiplayer_setup.dart';
import 'package:nyanya_rocket/screens/multiplayer/widgets/world_multiplayer_setup.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

class Multiplayer extends StatelessWidget {
  static final MultiplayerStore store = MultiplayerStore();

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text(NyaNyaLocalizations.of(context).multiplayerTitle),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: isPortrait ? Icon(FontAwesomeIcons.mobileAlt) : null,
                  text: NyaNyaLocalizations.of(context).deviceTab,
                ),
                Tab(
                  icon: isPortrait ? Icon(FontAwesomeIcons.networkWired) : null,
                  text: NyaNyaLocalizations.of(context).lanTab,
                ),
                Tab(
                  icon: isPortrait ? Icon(FontAwesomeIcons.globe) : null,
                  text: NyaNyaLocalizations.of(context).matchmakingTab,
                ),
              ],
            )),
        drawer: DefaultDrawer(),
        body: TabBarView(
          children: [
            DeviceMultiplayerSetup(),
            LanMultiplayerSetup(),
            WorldMultiplayerSetup()
          ],
        ),
      ),
    );
  }
}
