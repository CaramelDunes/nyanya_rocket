import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/blocs/multiplayer_queue.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/user.dart';
import 'package:nyanya_rocket/screens/multiplayer/tabs/friend_duel.dart';
import 'package:nyanya_rocket/screens/multiplayer/tabs/queue_and_leaderboard.dart';
import 'package:nyanya_rocket/screens/settings/region.dart';
import 'package:nyanya_rocket/screens/settings/settings.dart';
import 'package:provider/provider.dart';

import '../../widgets/bar_rail_tabs.dart';
import 'tabs/device_duel_setup.dart';
import 'tabs/lan_multiplayer_setup.dart';

class Multiplayer extends StatefulWidget {
  const Multiplayer({Key? key}) : super(key: key);

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
      if (token != null) {
        setState(() {
          _idToken = token;
        });
      }
    });
  }

  @override
  void dispose() {
    _idTokenSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<Region, User>(builder:
        (BuildContext context, Region region, User user, Widget? child) {
      return BarRailTabs(
          title: NyaNyaLocalizations.of(context).multiplayerTitle +
              ' (${region.label})',
          appBarActions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const Settings();
                }));
              },
            ),
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child:
                        Text(NyaNyaLocalizations.of(context).deviceDuelLabel),
                    value: 'device',
                  ),
                  PopupMenuItem(
                    child: Text(
                        NyaNyaLocalizations.of(context).lanMultiplayerLabel),
                    value: 'lan',
                  )
                ];
              },
              onSelected: (value) {
                if (value == 'lan') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LanMultiplayerSetup();
                  }));
                } else if (value == 'device') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const DeviceDuelSetup();
                  }));
                }
              },
            )
          ],
          tabs: [
            BarRailTab(
              icon: const FaIcon(FontAwesomeIcons.userFriends),
              label: NyaNyaLocalizations.of(context).duelLabel,
              content: QueueAndLeaderboard(
                queueType: QueueType.duels,
                displayName: user.displayName,
                idToken: _idToken!,
                masterServerHostname: region.masterServerHostname,
              ),
            ),
            BarRailTab(
                icon: const FaIcon(FontAwesomeIcons.users),
                label: NyaNyaLocalizations.of(context).fourPlayersLabel,
                content: QueueAndLeaderboard(
                  queueType: QueueType.fourPlayers,
                  displayName: user.displayName,
                  idToken: _idToken!,
                  masterServerHostname: region.masterServerHostname,
                )),
            BarRailTab(
                icon: const FaIcon(FontAwesomeIcons.peopleArrows),
                label: NyaNyaLocalizations.of(context).friendDuelLabel,
                content: FriendDuel(
                  displayName: user.displayName,
                  idToken: _idToken!,
                  masterServerHostname: region.masterServerHostname,
                ))
          ]);
    });
  }
}
