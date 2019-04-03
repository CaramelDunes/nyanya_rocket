import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';

class OverlayPopData {
  final bool playNext;

  OverlayPopData({@required this.playNext});
}

class SuccessOverlay extends StatelessWidget {
  final String succeededName;
  final String succeededPath;

  const SuccessOverlay({Key key, @required this.succeededName, this.succeededPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AbsorbPointer(),
        Material(
          color: Colors.black54,
          child: Column(
            children: <Widget>[
              Spacer(flex: 1),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          NyaNyaLocalizations.of(context).stageClearedText,
                          style: TextStyle(color: Colors.green, fontSize: 50),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                child: Text(NyaNyaLocalizations.of(context)
                                    .nextLevelLabel),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(OverlayPopData(playNext: true));
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  )),
                ],
              ),
              Spacer(flex: 3),
            ],
          ),
        )
      ],
    );
  }
}
