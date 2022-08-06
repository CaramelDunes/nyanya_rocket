import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';

class DiscardConfirmationDialog extends StatelessWidget {
  const DiscardConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(NyaNyaLocalizations.of(context).discardDialogTitle),
      content: Text(NyaNyaLocalizations.of(context).discardDialogMessage),
      actions: [
        TextButton(
          child: Text(NyaNyaLocalizations.of(context).yes.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        TextButton(
          child: Text(NyaNyaLocalizations.of(context).no.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
