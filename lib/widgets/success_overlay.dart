import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';

class OverlayPopData {
  final bool playNext;

  OverlayPopData({@required this.playNext});
}

class SuccessOverlay extends StatefulWidget {
  final String succeededName;
  final String succeededPath;

  const SuccessOverlay(
      {Key key, @required this.succeededName, this.succeededPath})
      : super(key: key);

  @override
  _SuccessOverlayState createState() => _SuccessOverlayState();
}

class _SuccessOverlayState extends State<SuccessOverlay> {
  int _stars;
  bool _plusOned = false;

  @override
  void initState() {
    super.initState();

    if (widget.succeededPath != null) {
      Firestore.instance
          .document(widget.succeededPath)
          .get()
          .then((DocumentSnapshot snapshot) {
        setState(() {
          _stars = snapshot.data['likes'];
        });
      });
    }
  }

  Widget _starAdder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.star,
            color: _plusOned ? Colors.green : null,
          ),
          onPressed: () {
            if (!_plusOned) {
              final DocumentReference postRef =
                  Firestore.instance.document(widget.succeededPath);
              Firestore.instance.runTransaction((Transaction tx) async {
                DocumentSnapshot postSnapshot = await tx.get(postRef);
                if (postSnapshot.exists) {
                  await tx.update(postRef, <String, dynamic>{
                    'likes': postSnapshot.data['likes'] + 1
                  });
                }
                print(widget.succeededPath);
              });

              setState(() {
                _plusOned = true;
                _stars += 1;
              });
            }
          },
        ),
        Text(_stars.toString())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AbsorbPointer(),
        Material(
          color: Colors.black54,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Spacer(flex: 2),
              Flexible(
                  flex: 0,
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            NyaNyaLocalizations.of(context).stageClearedText,
                            style: TextStyle(color: Colors.green, fontSize: 50),
                          ),
                          Visibility(
                              visible: widget.succeededPath != null &&
                                  _stars != null,
                              child: _starAdder()),
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            child: Text(
                                NyaNyaLocalizations.of(context).nextLevelLabel),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(OverlayPopData(playNext: true));
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
              Spacer(flex: 3),
            ],
          ),
        )
      ],
    );
  }
}
