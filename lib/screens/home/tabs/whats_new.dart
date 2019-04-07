import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/options_holder.dart';

class WhatsNew extends StatelessWidget {
  void _dismissWelcomeCard(BuildContext context) {
    OptionsHolder.of(context).options =
        OptionsHolder.of(context).options.copyWith(firstRun: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Visibility(
            visible: OptionsHolder.of(context).options.firstRun,
            child: Flexible(
              flex: 0,
              child: Dismissible(
                key: UniqueKey(),
                onDismissed: (DismissDirection direction) {
                  _dismissWelcomeCard(context);
                },
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          NyaNyaLocalizations.of(context).firstTimeWelcome,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                      Text(NyaNyaLocalizations.of(context).firstTimeText),
                      RaisedButton(
                        child: Text(NyaNyaLocalizations.of(context)
                            .firstTimeButtonLabel),
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
          ),
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Card(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.puzzlePiece,
                            size: 48,
                          ),
                          Text(
                            NyaNyaLocalizations.of(context).puzzlesTitle,
                            style: Theme.of(context).textTheme.subhead,
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/puzzles');
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.stopwatch,
                            size: 48,
                          ),
                          Text(
                            NyaNyaLocalizations.of(context).challengesTitle,
                            style: Theme.of(context).textTheme.subhead,
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/challenges');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Text(
            NyaNyaLocalizations.of(context).newsLabel,
            style: Theme.of(context).textTheme.headline,
          ),
          Expanded(
            flex: 3,
            child: FutureBuilder<QuerySnapshot>(
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
                        child:
                            Text(NyaNyaLocalizations.of(context).loadingLabel));
                  default:
                    return ListView(
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
            ),
          )
        ],
      ),
    );
  }
}
