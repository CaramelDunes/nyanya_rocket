import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nyanya_rocket/localization/nyanya_localizations.dart';

import '../services/firestore/firestore_service.dart';

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

    context
        .read<FirestoreService>()
        .getFeatureRequestThumbsUp(widget.featureId)
        .then((value) {
      if (mounted) {
        setState(() {
          _thumbsUp = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
                  context
                      .read<FirestoreService>()
                      .incrementFeatureRequestThumbsUp(widget.featureId);
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
