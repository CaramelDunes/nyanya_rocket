import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';

class Contributing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${NyaNyaLocalizations.of(context).contributorsLabel}:',
              style: Theme.of(context).textTheme.subtitle),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('contributors')
              .orderBy('name')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                    child: Text(NyaNyaLocalizations.of(context).loadingLabel));
              default:
                return Column(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return Text(document['name']);
                  }).toList(),
                );
            }
          },
        )
      ],
    );
  }
}
