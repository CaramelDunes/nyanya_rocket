import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/settings/account_management.dart';

class SignUpPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(NyaNyaLocalizations.of(context).loginPromptText),
        const SizedBox(height: 8.0),
        ElevatedButton(
            child: Text(NyaNyaLocalizations.of(context).loginButtonLabel),
            onPressed: () {
              AccountManagement.promptSignUp(context);
            })
      ],
    );
  }
}
