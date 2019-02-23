import 'package:flutter/material.dart';

class NotImplemented extends StatelessWidget {
  final String featureKey;

  const NotImplemented({Key key, this.featureKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Not (yet) implemented!\nLemme know if you want it to be a priority :)',
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.thumb_down,
                color: Colors.red,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.thumb_up,
                color: Colors.green,
              ),
              onPressed: () {},
            ),
          ],
        )
      ],
    );
  }
}
