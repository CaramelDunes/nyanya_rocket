import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:nyanya_rocket/contributors.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';

import '../../../config.dart';

class Contributing extends StatelessWidget {
  const Contributing({Key? key}) : super(key: key);

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
                  text: kProjectUrl,
                  style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontSize: 17),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launch(kProjectUrl);
                    })
            ],
          ),
        ),
        const Divider(),
        Text('${NyaNyaLocalizations.of(context).contributorsLabel}:',
            style: Theme.of(context).textTheme.subtitle1),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Contributors(),
        )
      ],
    );
  }
}
