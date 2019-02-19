import 'package:flutter/material.dart';

class OverlayPopData {
  final bool playNext;

  OverlayPopData({@required this.playNext});
}

class SuccessOverlay extends StatelessWidget {
  final String succeededName;

  const SuccessOverlay({Key key, @required this.succeededName})
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
                          "Stage Cleared!",
                          style: TextStyle(
                              fontFamily: "Kimberley",
                              color: Colors.green,
                              fontSize: 50),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: Text('Back'),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(OverlayPopData(playNext: false));
                              },
                            ),
                            RaisedButton(
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: Text('Next'),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(OverlayPopData(playNext: true));
                              },
                            ),
                          ],
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
