import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';

class NotImplemented extends StatefulWidget {
  final String featureId;

  const NotImplemented({Key? key, required this.featureId}) : super(key: key);

  @override
  _NotImplementedState createState() => _NotImplementedState();
}

class _NotImplementedState extends State<NotImplemented> {
  bool _thumbedUp = false;
  int? _thumbsUp;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('feature_requests')
        .doc(widget.featureId)
        .get()
        .then((value) {
      if (mounted) {
        var data = value.data();
        if (data != null) {
          setState(() {
            _thumbsUp = data['thumbs_up'];
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          NyaNyaLocalizations.of(context).notImplementedText,
          textAlign: TextAlign.center,
        ),
        IconButton(
          icon: Icon(
            Icons.thumb_up,
            color: _thumbedUp ? Colors.green : null,
          ),
          onPressed: _thumbedUp
              ? null
              : () {
                  final DocumentReference postRef = FirebaseFirestore.instance
                      .doc('feature_requests/${widget.featureId}');
                  postRef.update({'thumbs_up': FieldValue.increment(1)});
                  setState(() {
                    _thumbedUp = true;

                    if (_thumbsUp != null) {
                      _thumbsUp = _thumbsUp! + 1; //FIXME
                    }
                  });
                },
        ),
        Text(
          _thumbsUp?.toString() ?? '',
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
