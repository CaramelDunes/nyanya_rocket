import 'package:flutter/material.dart';

class Countdown extends StatelessWidget {
  final Duration remaining;
  final Color color;

  const Countdown({Key key, @required this.remaining, this.color})
      : super(key: key);

  static String formatDuration(Duration duration) {
    final String paddedMinutes = duration.inMinutes.toString().padLeft(2, '0');
    final String paddedSeconds =
        (duration.inSeconds % 60).toString().padLeft(2, '0');
    final String paddedMilliseconds =
        (duration.inMilliseconds % 1000).toString().padLeft(3, '0');
    final String minus = duration.isNegative ? '-' : '';

    return '$minus$paddedMinutes:$paddedSeconds.$paddedMilliseconds';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatDuration(remaining),
      style: Theme.of(context).textTheme.headline6.copyWith(color: color),
    );
  }
}
