import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:nyanya_rocket/app.dart';
import 'package:nyanya_rocket/contributors.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';

class Contributing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: 'Contribute to NyaNya Rocket!\n',
                  style: Theme.of(context).textTheme.headline6),
              TextSpan(
                text: NyaNyaLocalizations.of(context).contributingText,
              ),
              TextSpan(
                  text: App.projectUrl,
                  style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontSize: 17),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launch(App.projectUrl);
                    })
            ],
          ),
        ),
        Divider(),
        Text('${NyaNyaLocalizations.of(context).contributorsLabel}:',
            style: Theme.of(context).textTheme.subtitle1),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Contributors(),
        )
      ],
    );
  }
}
