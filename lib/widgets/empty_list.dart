import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      NyaNyaLocalizations.of(context).emptyListText,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 16,
      ),
    );
  }
}
