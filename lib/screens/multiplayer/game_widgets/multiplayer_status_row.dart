import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket_base/nyanya_rocket_base.dart';

import '../../../widgets/countdown.dart';
import 'event_wheel.dart';

class MultiplayerStatusRow extends StatelessWidget {
  final bool displayGameEvent;
  final GameEvent currentEvent;
  final ValueListenable<Duration> countdown;

  const MultiplayerStatusRow(
      {super.key,
      required this.displayGameEvent,
      required this.currentEvent,
      required this.countdown});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: ElevationOverlay.colorWithOverlay(
          colorScheme.surface, colorScheme.onSurface, 3.0),
      child: Row(
        children: [
          const Expanded(
            child: BackButton(),
          ),
          Expanded(
            child: Text(
              !displayGameEvent || currentEvent == GameEvent.None
                  ? ''
                  : currentEvent.name,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Duration>(
                valueListenable: countdown,
                builder: (context, remaining, snapshot) {
                  return Countdown(
                    remaining: remaining,
                    textAlign: TextAlign.center,
                  );
                }),
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
    );
  }
}
