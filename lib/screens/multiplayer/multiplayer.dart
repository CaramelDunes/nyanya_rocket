import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/screens/multiplayer/widgets/device_multiplayer_setup.dart';
import 'package:nyanya_rocket/screens/multiplayer/widgets/lan_multiplayer_setup.dart';
import 'package:nyanya_rocket/screens/multiplayer/widgets/world_multiplayer_setup.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

class Multiplayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text('Multiplayer'),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: isPortrait ? Icon(FontAwesomeIcons.mobileAlt) : null,
                  text: 'Device',
                ),
                Tab(
                  icon: isPortrait ? Icon(FontAwesomeIcons.networkWired) : null,
                  text: 'LAN',
                ),
                Tab(
                  icon: isPortrait ? Icon(FontAwesomeIcons.globe) : null,
                  text: 'World',
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
