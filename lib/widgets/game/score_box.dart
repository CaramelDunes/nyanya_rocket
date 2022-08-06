import 'package:flutter/material.dart';

class ScoreBox extends StatelessWidget {
  final String? label;
  final int score;
  final Color color;

  const ScoreBox({super.key, this.label, this.score = 0, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  child: FittedBox(
                    child: Text(
                      label ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
                    ),
                  )),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: FittedBox(
                  child: Text(
                    score.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
