import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/blocs/multiplayer_queue.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/multiplayer_store.dart';
import 'package:nyanya_rocket/models/user.dart';
import 'package:nyanya_rocket/screens/multiplayer/tabs/friend_duel.dart';
import 'package:nyanya_rocket/screens/multiplayer/tabs/queue_and_leaderboard.dart';
import 'package:nyanya_rocket/screens/settings/region.dart';
import 'package:nyanya_rocket/screens/settings/settings.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';
import 'package:provider/provider.dart';

import 'tabs/device_duel_setup.dart';
import 'tabs/lan_multiplayer_setup.dart';

class Multiplayer extends StatefulWidget {
  static final MultiplayerStore store = MultiplayerStore();

  @override
  _MultiplayerState createState() => _MultiplayerState();
}

class _MultiplayerState extends State<Multiplayer>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
//      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool displayIcons =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(NyaNyaLocalizations.of(context).multiplayerTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: displayIcons ? FaIcon(FontAwesomeIcons.userFriends) : null,
              text: NyaNyaLocalizations.of(context).duelLabel,
            ),
            Tab(
              icon: displayIcons ? FaIcon(FontAwesomeIcons.users) : null,
              text: NyaNyaLocalizations.of(context).fourPlayersLabel,
            ),
            Tab(
              icon: displayIcons ? FaIcon(FontAwesomeIcons.peopleArrows) : null,
              text: NyaNyaLocalizations.of(context).friendDuelLabel,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return Settings();
              }));
            },
          ),
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text(NyaNyaLocalizations.of(context).deviceDuelLabel),
                  value: 'device',
                ),
                PopupMenuItem(
                  child:
                      Text(NyaNyaLocalizations.of(context).lanMultiplayerLabel),
                  value: 'lan',
                )
              ];
            },
            onSelected: (value) {
              if (value == 'lan') {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LanMultiplayerSetup();
                }));
              } else if (value == 'device') {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DeviceDuelSetup();
                }));
              }
            },
          ),
        ],
      ),
      drawer: DefaultDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          Consumer<User>(
            builder: (BuildContext context, User user, Widget _) {
              return QueueAndLeaderboard(
                  queueType: QueueType.Duels, user: user);
            },
          ),
          Consumer<User>(
            builder: (BuildContext context, User user, Widget _) {
              return QueueAndLeaderboard(
                  queueType: QueueType.FourPlayers, user: user);
            },
          ),
          Consumer<User>(
            builder: (BuildContext context, User user, Widget _) {
              return FriendDuel(
                  user: user,
                  masterServerHostname:
                      Provider.of<Region>(context, listen: false)
                          .masterServerHostname);
            },
          )
        ],
      ),
    );
  }
}
