import 'package:flutter/material.dart';

import 'default_drawer/default_drawer.dart';

class BarRailTab {
  final Widget content;
  final String label;
  final Widget icon;

  BarRailTab({required this.content, required this.label, required this.icon});
}

class BarRailTabs extends StatefulWidget {
  final String title;
  final int initialTab;
  final List<BarRailTab> tabs;
  final List<Widget>? appBarActions;

  const BarRailTabs(
      {Key? key,
      required this.title,
      required this.tabs,
      this.initialTab = 0,
      this.appBarActions})
      : super(key: key);

  @override
  _BarRailTabsState createState() => _BarRailTabsState();
}

class _BarRailTabsState extends State<BarRailTabs> {
  late int _selectedTab;

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
          return _buildLandscape(context);
        } else {
          return _buildPortrait(context);
        }
      },
    );
  }

  Widget _buildPortrait(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: const DefaultDrawer(),
      body: widget.tabs[_selectedTab].content,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (i) => setState(() {
          _selectedTab = i;
        }),
        destinations: _makeNavigationList(NavigationDestination.new),
      ),
    );
  }

  Widget _buildLandscape(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        drawer: const DefaultDrawer(),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedTab,
              labelType: NavigationRailLabelType.all,
              onDestinationSelected: (i) => setState(() {
                _selectedTab = i;
              }),
              destinations: _makeNavigationList((
                      {required icon, required label}) =>
                  NavigationRailDestination(icon: icon, label: Text(label))),
            ),
            Expanded(child: widget.tabs[_selectedTab].content)
          ],
        ));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(widget.title),
      actions: widget.appBarActions,
    );
  }

  List<T> _makeNavigationList<T>(
      T Function({required Widget icon, required String label}) f) {
    return widget.tabs
        .map((BarRailTab tab) => f(icon: tab.icon, label: tab.label))
        .toList();
  }
}
