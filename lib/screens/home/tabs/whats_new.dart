import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/settings/first_run.dart';
import 'package:provider/provider.dart';

class WhatsNew extends StatelessWidget {
  void _dismissWelcomeCard(BuildContext context) {
    Provider.of<FirstRun>(context, listen: false).enabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(
          visible: Provider.of<FirstRun>(context).enabled,
          child: Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) {
              _dismissWelcomeCard(context);
            },
            child: Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      NyaNyaLocalizations.of(context).firstTimeWelcome,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Text(NyaNyaLocalizations.of(context).firstTimeText),
                  RaisedButton(
                    child: Text(
                        NyaNyaLocalizations.of(context).firstTimeButtonLabel),
                    onPressed: () {
                      _dismissWelcomeCard(context);
                      Navigator.pushNamed(context, '/tutorial');
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: _buildShortcutCard(
                      context: context,
                      faIcon: FontAwesomeIcons.puzzlePiece,
                      name: NyaNyaLocalizations.of(context).puzzlesTitle,
                      routeName: '/puzzles')),
              Expanded(
                  child: _buildShortcutCard(
                      context: context,
                      faIcon: FontAwesomeIcons.stopwatch,
                      name: NyaNyaLocalizations.of(context).challengesTitle,
                      routeName: '/challenges')),
              Expanded(
                  child: _buildShortcutCard(
                      context: context,
                      faIcon: FontAwesomeIcons.gamepad,
                      name: NyaNyaLocalizations.of(context).multiplayerTitle,
                      routeName: '/multiplayer'))
            ],
          ),
        ),
        Divider(height: 8.0),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            children: <Widget>[
              Text(
                NyaNyaLocalizations.of(context).newsLabel,
                style: Theme.of(context).textTheme.headline5,
              ),
              FutureBuilder<QuerySnapshot>(
                future: Firestore.instance
                    .collection(
                        'articles_${Intl.shortLocale(Intl.getCurrentLocale())}')
                    .orderBy('date', descending: true)
                    .getDocuments(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                          child: Text(
                              NyaNyaLocalizations.of(context).loadingLabel));
                    default:
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return ListTile(
                            title: Text(document['title']),
                            trailing: Text(MaterialLocalizations.of(context)
                                .formatMediumDate(document['date'].toDate())),
                          );
                        }).toList(),
                      );
                  }
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShortcutCard(
      {BuildContext context, IconData faIcon, String name, String routeName}) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FaIcon(faIcon, size: 48),
              const SizedBox(height: 4.0),
              Text(
                name,
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
      ),
    );
  }
}
