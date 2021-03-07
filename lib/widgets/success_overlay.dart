import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/routing/nyanya_route_path.dart';

enum OverlayResult { PlayNext, PlayAgain }

class SuccessOverlay extends StatefulWidget {
  final String succeededName;
  final String? succeededPath;
  final NyaNyaRoutePath? nextRoutePath;
  final bool canPlayAgain;

  const SuccessOverlay(
      {Key? key,
      required this.succeededName,
      this.nextRoutePath,
      required this.canPlayAgain,
      this.succeededPath})
      : super(key: key);

  @override
  _SuccessOverlayState createState() => _SuccessOverlayState();
}

class _SuccessOverlayState extends State<SuccessOverlay> {
  int? _stars;
  bool _plusOned = false;

  @override
  void initState() {
    super.initState();

    if (widget.succeededPath != null) {
      FirebaseFirestore.instance
          .doc(widget.succeededPath!)
          .get()
          .then((DocumentSnapshot snapshot) {
        setState(() {
          _stars = snapshot.get('likes');
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
                  FirebaseFirestore.instance.doc(widget.succeededPath!);
              postRef.update({'likes': FieldValue.increment(1)});

              setState(() {
                _plusOned = true;

                if (_stars != null) {
                  _stars = _stars! + 1;
                }
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
              Container(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
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
                          visible:
                              widget.succeededPath != null && _stars != null,
                          child: _starAdder()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            child: Text(
                                NyaNyaLocalizations.of(context).playAgainLabel),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(OverlayResult.PlayAgain);
                            },
                          ),
                          ElevatedButton(
                            child: Text(widget.nextRoutePath != null
                                ? NyaNyaLocalizations.of(context).nextLevelLabel
                                : NyaNyaLocalizations.of(context).back),
                            onPressed: () {
                              if (widget.nextRoutePath != null)
                                Router.of(context)
                                    .routerDelegate
                                    .setNewRoutePath(widget.nextRoutePath);
                              else
                                Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(flex: 3),
            ],
          ),
        )
      ],
    );
  }
}
