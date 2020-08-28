import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/blocs/multiplayer_queue.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/multiplayer_store.dart';
import 'package:nyanya_rocket/screens/multiplayer/setup_widgets/signup_prompt.dart';
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
  String _displayName;
  String _idToken;
  StreamSubscription _idTokenSubscription;

  @override
  void initState() {
    super.initState();

    _displayName = auth.FirebaseAuth.instance.currentUser?.displayName;

    _idTokenSubscription =
        auth.FirebaseAuth.instance.idTokenChanges().listen((user) {
      if (user != null && mounted) {
        _displayName = user.displayName;
        user.getIdToken().then((String token) {
          setState(() {
            _idToken = token;
          });
        });
      } else {
        setState(() {
          _idToken = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _idTokenSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool displayIcons =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return DefaultTabController(
        length: 3,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(NyaNyaLocalizations.of(context).multiplayerTitle),
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: displayIcons
                        ? FaIcon(FontAwesomeIcons.userFriends)
                        : null,
                    text: NyaNyaLocalizations.of(context).duelLabel,
                  ),
                  Tab(
                    icon: displayIcons ? FaIcon(FontAwesomeIcons.users) : null,
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
            body: _displayName == null
                ? Center(child: SignUpPrompt())
                : _idToken == null
                    ? CircularProgressIndicator()
                    : TabBarView(
                        children: [
                          QueueAndLeaderboard(
                            queueType: QueueType.Duels,
                            displayName: _displayName,
                            idToken: _idToken,
                          ),
                          QueueAndLeaderboard(
                              queueType: QueueType.FourPlayers,
                              displayName: _displayName,
                              idToken: _idToken),
                          FriendDuel(
                              displayName: _displayName,
                              idToken: _idToken,
                              masterServerHostname:
                                  Provider.of<Region>(context, listen: false)
                                      .masterServerHostname)
                        ],
                      )));
  }
}
