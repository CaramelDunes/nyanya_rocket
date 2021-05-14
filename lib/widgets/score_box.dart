import 'package:flutter/material.dart';

class ScoreBox extends StatelessWidget {
  final String? label;
  final int score;
  final Color color;

  const ScoreBox({Key? key, this.label, this.score = 0, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      color: color,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Container(
                child: Text(
                  label ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
                padding: const EdgeInsets.all(2.0),
                constraints: const BoxConstraints(minWidth: 80),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)))),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 4.0),
            child: Container(
              child: Center(
                child: Text(
                  score.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              padding: const EdgeInsets.all(8.0),
              constraints: const BoxConstraints(minWidth: 80),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
            ),
          )
        ],
      ),
    );
  }
}
