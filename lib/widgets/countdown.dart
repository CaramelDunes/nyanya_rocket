import 'package:flutter/material.dart';

class Countdown extends StatelessWidget {
  final Duration remaining;
  final Color? color;
  final TextAlign? textAlign;

  const Countdown(
      {super.key, required this.remaining, this.color, this.textAlign});

  static String formatDuration(Duration duration) {
    final String paddedMinutes =
        duration.inMinutes.abs().toString().padLeft(2, '0');
    final String paddedSeconds =
        (duration.inSeconds % 60).toString().padLeft(2, '0');
    final int tenthOfASecond = duration.inMilliseconds % 1000 ~/ 100;
    final String minus = duration.isNegative ? '-' : '';

    return '$minus$paddedMinutes:$paddedSeconds.$tenthOfASecond';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatDuration(remaining),
      textAlign: textAlign,
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: color),
    );
  }
}
