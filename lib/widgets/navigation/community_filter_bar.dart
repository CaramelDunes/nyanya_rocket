import 'package:flutter/material.dart';

import '../../localization/nyanya_localizations.dart';
import '../../services/firestore/firestore_service.dart';

class CommunityFilterBar extends StatelessWidget {
  final Sorting value;
  final ValueChanged<Sorting?> onSortingChanged;
  final VoidCallback onRefresh;

  const CommunityFilterBar(
      {super.key,
      required this.value,
      required this.onSortingChanged,
      required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            NyaNyaLocalizations.of(context).sortByLabel,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const VerticalDivider(),
          Expanded(
            child: DropdownButton<Sorting>(
              isExpanded: true,
              value: value,
              items: <DropdownMenuItem<Sorting>>[
                DropdownMenuItem<Sorting>(
                  value: Sorting.byDate,
                  child: Text(NyaNyaLocalizations.of(context).dateLabel),
                ),
                DropdownMenuItem<Sorting>(
                  value: Sorting.byName,
                  child: Text(NyaNyaLocalizations.of(context).nameLabel),
                ),
                DropdownMenuItem<Sorting>(
                  value: Sorting.byPopularity,
                  child: Text(NyaNyaLocalizations.of(context).popularityLabel),
                )
              ],
              onChanged: onSortingChanged,
            ),
          ),
          IconButton(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              tooltip: NyaNyaLocalizations.of(context).refreshLabel)
        ],
      ),
    );
  }
}
