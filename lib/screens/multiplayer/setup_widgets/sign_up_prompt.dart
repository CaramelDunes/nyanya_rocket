import 'package:flutter/material.dart';

import '../../../localization/nyanya_localizations.dart';
import '../../settings/account_management.dart';

class SignUpPrompt extends StatelessWidget {
  const SignUpPrompt({Key? key}) : super(key: key);

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
