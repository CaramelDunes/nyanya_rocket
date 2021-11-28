import 'package:flutter/material.dart';

import '../localization/nyanya_localizations.dart';
import '../services/firestore/firestore_service.dart';

class CommunityFilterBar extends StatelessWidget {
  final Sorting value;
  final ValueChanged<Sorting?> onSortingChanged;
  final VoidCallback onRefresh;

  const CommunityFilterBar(
      {Key? key,
      required this.value,
      required this.onSortingChanged,
      required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
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
                  child: Text(NyaNyaLocalizations.of(context).dateLabel),
                  value: Sorting.byDate,
                ),
                DropdownMenuItem<Sorting>(
                  child: Text(NyaNyaLocalizations.of(context).nameLabel),
                  value: Sorting.byName,
                ),
                DropdownMenuItem<Sorting>(
                  child: Text(NyaNyaLocalizations.of(context).popularityLabel),
                  value: Sorting.byPopularity,
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
