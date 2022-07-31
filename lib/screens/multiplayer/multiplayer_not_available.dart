import 'package:flutter/material.dart';

import '../../localization/nyanya_localizations.dart';
import 'tabs/device_duel_setup.dart';

class MultiplayerNotAvailable extends StatelessWidget {
  const MultiplayerNotAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    final localized = NyaNyaLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localized.multiplayerTitle),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localized.multiplayerNotAvailableText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const DeviceDuelSetup();
                  }));
                },
                child: Text(localized.deviceDuelLabel))
          ],
        ),
      ),
    );
  }
}
