import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WhatsNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Flexible(
          child: Dismissible(
            key: UniqueKey(),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome!',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  Text('First time here? Check the tutorial!'),
                  RaisedButton(
                    child: Text('Take me to it'),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/tutorial');
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('articles').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: Text('Loading...'));
                default:
                  return ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return ExpansionTile(
                        title: Text(document['title']),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(document['body']),
                          )
                        ],
                        trailing: Text(MaterialLocalizations.of(context)
                            .formatMediumDate(document['date'])),
                      );
                    }).toList(),
                  );
              }
            },
          ),
        )
      ],
    );
  }
}
