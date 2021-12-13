import 'package:flutter/material.dart';

import '../../../localization/nyanya_localizations.dart';
import '../tabs/device_duel_setup.dart';
import '../tabs/lan_multiplayer_setup.dart';

enum ExtraMultiplayerOptions { device, lan }

class ExtraMultiplayerMenu extends StatelessWidget {
  const ExtraMultiplayerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localized = NyaNyaLocalizations.of(context);

    return PopupMenuButton<ExtraMultiplayerOptions>(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            child: Text(localized.deviceDuelLabel),
            value: ExtraMultiplayerOptions.device,
          ),
          PopupMenuItem(
            child: Text(localized.lanMultiplayerLabel),
            value: ExtraMultiplayerOptions.lan,
          )
        ];
      },
      onSelected: (value) {
        if (value == ExtraMultiplayerOptions.lan) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const LanMultiplayerSetup();
          }));
        } else if (value == ExtraMultiplayerOptions.device) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const DeviceDuelSetup();
          }));
        }
      },
    );
  }
}
