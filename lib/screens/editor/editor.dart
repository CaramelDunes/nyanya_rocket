import 'package:flutter/material.dart';
import 'package:nyanya_rocket/screens/editor/widgets/create_tab.dart';
import 'package:nyanya_rocket/screens/editor/widgets/edit_tab.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

enum EditorMode { Puzzle, Challenge, Multiplayer }

class Editor extends StatefulWidget {
  @override
  EditorState createState() {
    return new EditorState();
  }
}

class EditorState extends State<Editor> {
  String name;
  EditorMode mode;

  @override
  void initState() {
    super.initState();

    mode = EditorMode.Puzzle;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Editor'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.add), text: 'New'),
              Tab(icon: Icon(Icons.edit), text: 'Edit'),
            ],
          ),
        ),
        drawer: DefaultDrawer(),
        body: TabBarView(
          children: [
            CreateTab(),
            EditTab(),
          ],
        ),
      ),
    );
  }
}
