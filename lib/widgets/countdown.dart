import 'package:flutter/material.dart';

class Countdown extends StatelessWidget {
  final Duration remaining;

  const Countdown({Key key, this.remaining}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '${remaining.inMinutes.toString().padLeft(2, '0')}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    );
  }
}
