import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';

class NotImplemented extends StatelessWidget {
  final String featureId;

  const NotImplemented({Key key, @required this.featureId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          NyaNyaLocalizations.of(context).notImplementedText,
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.thumb_up,
                color: Colors.green,
              ),
              onPressed: () {
                final DocumentReference postRef =
                    Firestore.instance.document('feature_requests/$featureId');
                Firestore.instance.runTransaction((Transaction tx) async {
                  DocumentSnapshot postSnapshot = await tx.get(postRef);
                  if (postSnapshot.exists) {
                    await tx.update(postRef, <String, dynamic>{
                      'thumbs_up': postSnapshot.data['thumbs_up'] + 1
                    });
                  }
                });
              },
            ),
          ],
        ),
        StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('feature_requests')
              .document(featureId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                    child: Text(NyaNyaLocalizations.of(context).loadingLabel));
              default:
                return Text(
                  snapshot.data['thumbs_up'].toString(),
                  textAlign: TextAlign.center,
                );
            }
          },
        )
      ],
    );
  }
}
