import 'package:flutter/material.dart';

class ScoreBox extends StatelessWidget {
  final String label;
  final int score;
  final Color color;

  const ScoreBox({Key key, this.label, this.score = 0, @required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Container(
                  child: Center(child: Text(label ?? '')),
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)))),
            ),
          ),
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
              child: Container(
                child: Center(
                  child: Text(
                    score.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
              ),
            ),
          )
        ],
      ),
    );
  }
}
