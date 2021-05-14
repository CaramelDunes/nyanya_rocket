import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';

class MultiplayerNotAvailable extends StatelessWidget {
  const MultiplayerNotAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(NyaNyaLocalizations.of(context).multiplayerTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            NyaNyaLocalizations.of(context).multiplayerNotAvailableText,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
