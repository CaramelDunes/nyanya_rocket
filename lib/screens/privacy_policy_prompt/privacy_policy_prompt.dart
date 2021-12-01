import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';

import '../../config.dart';

class PrivacyPolicyPrompt extends StatelessWidget {
  final bool askUser;

  const PrivacyPolicyPrompt({Key? key, required this.askUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(NyaNyaLocalizations.of(context).privacyPolicyLabel)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kMaxWidthForBigScreens),
          child: const SingleChildScrollView(
              padding: EdgeInsets.all(8.0), child: Text(kPrivacyPolicyText)),
        ),
      ),
      persistentFooterButtons: askUser
          ? [
              TextButton(
                child:
                    Text(NyaNyaLocalizations.of(context).accept.toUpperCase()),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              TextButton(
                child: Text(NyaNyaLocalizations.of(context).deny.toUpperCase()),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              )
            ]
          : null,
    );
  }
}
