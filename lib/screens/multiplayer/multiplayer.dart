import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/multiplayer_store.dart';
import 'package:nyanya_rocket/models/user.dart';
import 'package:nyanya_rocket/screens/multiplayer/widgets/local_duel_setup.dart';
import 'package:nyanya_rocket/screens/multiplayer/widgets/lan_multiplayer_setup.dart';
import 'package:nyanya_rocket/screens/multiplayer/widgets/world_multiplayer_setup.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';
import 'package:provider/provider.dart';

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
      FocusScope.of(context).unfocus();
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
      appBar: AppBar(
          title: Text(NyaNyaLocalizations.of(context).multiplayerTitle),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: displayIcons ? FaIcon(FontAwesomeIcons.globe) : null,
                text: NyaNyaLocalizations.of(context).matchmakingTab,
              ),
              Tab(
                icon: displayIcons ? FaIcon(FontAwesomeIcons.mobileAlt) : null,
                text: NyaNyaLocalizations.of(context).localDuelTab,
              ),
              Tab(
                icon:
                    displayIcons ? FaIcon(FontAwesomeIcons.networkWired) : null,
                text: NyaNyaLocalizations.of(context).lanTab,
              ),
            ],
          )),
      drawer: DefaultDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          Consumer<User>(
              builder: (context2, user, _) =>
                  WorldMultiplayerSetup(user: user)),
          LocalDuelSetup(),
          LanMultiplayerSetup(),
        ],
      ),
    );
  }
}
