import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../blocs/multiplayer_queue.dart';
import '../../localization/nyanya_localizations.dart';
import '../../models/user.dart';
import '../../widgets/navigation/bar_rail_tabs.dart';
import '../../widgets/navigation/settings_action.dart';
import '../settings/region.dart';
import 'setup_widgets/extra_multiplayer_menu.dart';
import 'setup_widgets/sign_up_prompt.dart';
import 'tabs/friend_duel.dart';
import 'tabs/queue_and_leaderboard.dart';

typedef IdTokenBuilder = Widget Function(String idToken);

class Multiplayer extends StatelessWidget {
  const Multiplayer({super.key});

  @override
  Widget build(BuildContext context) {
    final localized = NyaNyaLocalizations.of(context);

    return Consumer2<Region, User>(builder:
        (BuildContext context, Region region, User user, Widget? child) {
      return FutureBuilder(
          future: user.idToken(),
          builder: (context, AsyncSnapshot<String?> snapshot) {
            return BarRailTabs(
                title: '${localized.multiplayerTitle} (${region.label})',
                appBarActions: const [
                  SettingsAction(),
                  ExtraMultiplayerMenu()
                ],
                tabs: [
                  BarRailTab(
                    icon: const FaIcon(FontAwesomeIcons.userGroup),
                    label: localized.duelLabel,
                    content: _wrapWithSignupPrompt(
                        snapshot,
                        (idToken) => QueueAndLeaderboard(
                              key: const ValueKey('DuelsQueue'),
                              queueType: QueueType.duels,
                              displayName: user.displayName ?? '',
                              idToken: snapshot.data!,
                              masterServerHostname: region.masterServerHostname,
                            )),
                  ),
                  BarRailTab(
                      icon: const FaIcon(FontAwesomeIcons.users),
                      label: localized.fourPlayersLabel,
                      content: _wrapWithSignupPrompt(
                          snapshot,
                          (idToken) => QueueAndLeaderboard(
                                key: const ValueKey('FoursQueue'),
                                queueType: QueueType.fourPlayers,
                                displayName: user.displayName ?? '',
                                idToken: snapshot.data!,
                                masterServerHostname:
                                    region.masterServerHostname,
                              ))),
                  BarRailTab(
                      icon: const FaIcon(FontAwesomeIcons.peopleArrows),
                      label: localized.friendDuelLabel,
                      content: _wrapWithSignupPrompt(
                          snapshot,
                          (idToken) => FriendDuel(
                              displayName: user.displayName ?? '',
                              idToken: idToken,
                              masterServerHostname:
                                  region.masterServerHostname)))
                ]);
          });
    });
  }

  Widget _wrapWithSignupPrompt(
      AsyncSnapshot<String?> idTokenSnapshot, IdTokenBuilder idTokenBuilder) {
    if (idTokenSnapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (!idTokenSnapshot.hasData) {
      return const Center(child: SignUpPrompt());
    }

    return idTokenBuilder(idTokenSnapshot.data!);
  }
}
