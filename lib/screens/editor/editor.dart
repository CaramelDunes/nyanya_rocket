import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/editor/widgets/create_tab.dart';
import 'package:nyanya_rocket/screens/editor/widgets/edit_tab.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

enum EditorMode { Puzzle, Challenge, Multiplayer }

class Editor extends StatefulWidget {
  @override
  _EditorState createState() {
    return _EditorState();
  }
}

class _EditorState extends State<Editor> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(NyaNyaLocalizations.of(context).editorTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
                icon: Icon(Icons.add),
                text: NyaNyaLocalizations.of(context).newTab),
            Tab(
                icon: Icon(Icons.edit),
                text: NyaNyaLocalizations.of(context).editTab),
          ],
        ),
      ),
      drawer: DefaultDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          CreateTab(),
          EditTab(),
        ],
      ),
    );
  }
}
