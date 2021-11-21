import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';
import 'package:nyanya_rocket/screens/challenges/tabs/community_challenges.dart';
import 'package:nyanya_rocket/screens/challenges/tabs/local_challenges.dart';
import 'package:nyanya_rocket/screens/challenges/tabs/original_challenges.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

class Challenges extends StatefulWidget {
  final TabKind initialTab;

  const Challenges({Key? key, this.initialTab = TabKind.original})
      : super(key: key);

  @override
  State<Challenges> createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  late TabKind _selectedTab;

  @override
  void initState() {
    super.initState();

    _selectedTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.landscape ||
            MediaQuery.of(context).size.width >= 270 * 2.5) {
          return _buildLandscape();
        } else {
          return _buildPortrait();
        }
      },
    );
  }

  Widget _buildPortrait() {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: const DefaultDrawer(),
      body: _buildContent(_selectedTab),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab.index,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (i) => setState(() {
          _selectedTab = TabKind.values[i];
        }),
        destinations: _makeNavigationList(NavigationDestination.new),
      ),
    );
  }

  Widget _buildLandscape() {
    return Scaffold(
        appBar: _buildAppBar(),
        drawer: const DefaultDrawer(),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedTab.index,
              labelType: NavigationRailLabelType.all,
              onDestinationSelected: (i) => setState(() {
                _selectedTab = TabKind.values[i];
              }),
              destinations: _makeNavigationList((
                      {required icon, required label}) =>
                  NavigationRailDestination(icon: icon, label: Text(label))),
            ),
            Expanded(child: _buildContent(_selectedTab))
          ],
        ));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: Text(NyaNyaLocalizations.of(context).challengesTitle));
  }

  Widget _buildContent(TabKind tabKind) {
    switch (tabKind) {
      case TabKind.original:
        return const OriginalChallenges();
      case TabKind.community:
        return const CommunityChallenges();
      case TabKind.local:
        return const LocalChallenges();
    }
  }

  List<T> _makeNavigationList<T>(
      T Function({required Widget icon, required String label}) f) {
    return [
      f(
        icon: const FaIcon(FontAwesomeIcons.stopwatch),
        label: NyaNyaLocalizations.of(context).originalTab,
      ),
      f(
        icon: const FaIcon(FontAwesomeIcons.globe),
        label: NyaNyaLocalizations.of(context).communityTab,
      ),
      f(
        icon: const FaIcon(FontAwesomeIcons.mobileAlt),
        label: NyaNyaLocalizations.of(context).deviceTab,
      )
    ];
  }
}
