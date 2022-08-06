import 'package:flutter/material.dart';

import '../../localization/nyanya_localizations.dart';
import '../../utils.dart';

class CompletionIndicator extends StatelessWidget {
  final double completedRatio;
  final bool showCompleted;
  final ValueChanged<bool?> onChanged;

  const CompletionIndicator(
      {super.key,
      required this.completedRatio,
      required this.showCompleted,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final localized = NyaNyaLocalizations.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      // Use same color as NavigationBar.
      color: ElevationOverlay.colorWithOverlay(
          colorScheme.surface, colorScheme.onSurface, 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
              localized
                  .completedPercentLabel(ratioToPercentage(completedRatio)),
              textAlign: TextAlign.center),
          Row(
            children: [
              Text(localized.showCompletedLabel.toUpperCase()),
              Switch(
                value: showCompleted,
                onChanged: onChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
