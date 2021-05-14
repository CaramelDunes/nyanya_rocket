import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/blocs/multiplayer_queue.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/user.dart';
import 'package:nyanya_rocket/screens/multiplayer/setup_widgets/sign_up_prompt.dart';
import 'package:nyanya_rocket/screens/multiplayer/tabs/friend_duel.dart';
import 'package:nyanya_rocket/screens/multiplayer/tabs/queue_and_leaderboard.dart';
import 'package:nyanya_rocket/screens/settings/region.dart';
import 'package:nyanya_rocket/screens/settings/settings.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';
import 'package:provider/provider.dart';

import 'tabs/device_duel_setup.dart';
import 'tabs/lan_multiplayer_setup.dart';

class Multiplayer extends StatefulWidget {
  @override
  _MultiplayerState createState() => _MultiplayerState();
}

class _MultiplayerState extends State<Multiplayer>
    with SingleTickerProviderStateMixin {
  String? _idToken;
  StreamSubscription? _idTokenSubscription;

  @override
  void initState() {
    super.initState();

    final user = context.read<User>();

    // FIXME
    // _idTokenSubscription = user.signedInStream.listen((signedIn) {
    //   if (mounted) {
    //     print(signedIn);
    //     if (signedIn) {
    //       user.idToken().then((String? token) {
    //         if (token != null)
    //           setState(() {
    //             _idToken = token;
    //           });
    //       });
    //     }
    //   }
    // });

    user.idToken().then((String? token) {
      if (token != null)
        setState(() {
          _idToken = token;
        });
    });
  }

  @override
  void dispose() {
    _idTokenSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool displayIcons =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return DefaultTabController(
        length: 3,
        child: Consumer2<Region, User>(builder:
            (BuildContext context, Region region, User user, Widget? child) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text(NyaNyaLocalizations.of(context).multiplayerTitle +
                    ' (${region.label})'),
                bottom: TabBar(
                  tabs: [
                    Tab(
                      icon: displayIcons
                          ? FaIcon(FontAwesomeIcons.userFriends)
                          : null,
                      text: NyaNyaLocalizations.of(context).duelLabel,
                    ),
                    Tab(
                      icon:
                          displayIcons ? FaIcon(FontAwesomeIcons.users) : null,
                      text: NyaNyaLocalizations.of(context).fourPlayersLabel,
                    ),
                    Tab(
                      icon: displayIcons
                          ? FaIcon(FontAwesomeIcons.peopleArrows)
                          : null,
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
                          child: Text(
                              NyaNyaLocalizations.of(context).deviceDuelLabel),
                          value: 'device',
                        ),
                        PopupMenuItem(
                          child: Text(NyaNyaLocalizations.of(context)
                              .lanMultiplayerLabel),
                          value: 'lan',
                        )
                      ];
                    },
                    onSelected: (value) {
                      if (value == 'lan') {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LanMultiplayerSetup();
                        }));
                      } else if (value == 'device') {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return DeviceDuelSetup();
                        }));
                      }
                    },
                  ),
                ],
              ),
              drawer: DefaultDrawer(),
              body: _idToken == null
                  ? Center(child: SignUpPrompt())
                  : TabBarView(
                      children: [
                        QueueAndLeaderboard(
                          queueType: QueueType.Duels,
                          displayName: user.displayName,
                          idToken: _idToken!,
                          masterServerHostname: region.masterServerHostname,
                        ),
                        QueueAndLeaderboard(
                          queueType: QueueType.FourPlayers,
                          displayName: user.displayName,
                          idToken: _idToken!,
                          masterServerHostname: region.masterServerHostname,
                        ),
                        FriendDuel(
                          displayName: user.displayName,
                          idToken: _idToken!,
                          masterServerHostname: region.masterServerHostname,
                        )
                      ],
                    ));
        }));
  }
}
