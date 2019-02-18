import 'package:flutter/material.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NyaNya Rocket !'),
      ),
      drawer: DefaultDrawer(),
      body: Column(
        children: <Widget>[Text('Welcome!'), Divider(), Text('News')],
      ),
    );
  }
}
