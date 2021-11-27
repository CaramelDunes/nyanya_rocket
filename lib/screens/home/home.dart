import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/home/tabs/whats_new.dart';
import 'package:nyanya_rocket/widgets/default_drawer/default_drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(NyaNyaLocalizations.of(context).homeTitle)),
      drawer: const DefaultDrawer(),
      body: const WhatsNew(),
    );
  }
}
