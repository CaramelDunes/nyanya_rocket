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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<Region, User>(builder:
        (BuildContext context, Region region, User user, Widget? child) {
      return FutureBuilder(
          future: user.idToken(),
          builder: (context, AsyncSnapshot<String?> snapshot) {
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
                          return const LanMultiplayerSetup();
                        }));
                      } else if (value == 'device') {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
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
                    content: Builder(builder: (context) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (!snapshot.hasData) {
                        return Center(
                            child: Text(NyaNyaLocalizations.of(context)
                                .unauthenticatedError));
                      }

                      return QueueAndLeaderboard(
                        queueType: QueueType.duels,
                        displayName: user.displayName ?? '',
                        idToken: snapshot.data!,
                        masterServerHostname: region.masterServerHostname,
                      );
                    }),
                  ),
                  BarRailTab(
                      icon: const FaIcon(FontAwesomeIcons.users),
                      label: NyaNyaLocalizations.of(context).fourPlayersLabel,
                      content: Builder(builder: (context) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (!snapshot.hasData) {
                          return Center(
                              child: Text(NyaNyaLocalizations.of(context)
                                  .unauthenticatedError));
                        }

                        return QueueAndLeaderboard(
                          queueType: QueueType.fourPlayers,
                          displayName: user.displayName ?? '',
                          idToken: snapshot.data!,
                          masterServerHostname: region.masterServerHostname,
                        );
                      })),
                  BarRailTab(
                      icon: const FaIcon(FontAwesomeIcons.peopleArrows),
                      label: NyaNyaLocalizations.of(context).friendDuelLabel,
                      content: Builder(builder: (context) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (!snapshot.hasData) {
                          return Center(
                              child: Text(NyaNyaLocalizations.of(context)
                                  .unauthenticatedError));
                        }

                        return FriendDuel(
                          displayName: user.displayName ?? '',
                          idToken: snapshot.data!,
                          masterServerHostname: region.masterServerHostname,
                        );
                      }))
                ]);
          });
    });
  }
}
