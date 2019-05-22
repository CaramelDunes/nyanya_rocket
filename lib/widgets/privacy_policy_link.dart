import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/app.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyLink extends StatelessWidget {
  const PrivacyPolicyLink({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: NyaNyaLocalizations.of(context).aboutDialogText,
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(
              text: App.privacyPolicyUrl,
              style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 15),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launch(App.privacyPolicyUrl);
                })
        ],
      ),
    );
  }
}
