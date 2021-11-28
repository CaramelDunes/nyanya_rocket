import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config.dart';
import '../../localization/nyanya_localizations.dart';
import '../../models/user.dart';
import 'account_management.dart';
import 'dark_mode.dart';
import 'language.dart';
import 'region.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(NyaNyaLocalizations.of(context).settingsTitle),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kMaxWidthForBigScreens),
            child: ListView(
              children: <Widget>[
                _buildDarkModeTile(context),
                _buildLanguageTile(context),
                _buildRegionTile(context),
                Consumer<User>(
                  builder: (context, user, _) =>
                      _buildAccountManagementTile(context, user),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildDarkModeTile(BuildContext context) {
    return SwitchListTile(
      title: Text(NyaNyaLocalizations.of(context).darkModeLabel),
      onChanged: (bool value) {
        Provider.of<DarkMode>(context, listen: false).enabled = value;
      },
      value: Provider.of<DarkMode>(context).enabled,
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return ListTile(
      title: Text(NyaNyaLocalizations.of(context).languageLabel),
      trailing: DropdownButton<String>(
          value: Provider.of<Language>(context).value,
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem(
              child: Text('Auto'),
              value: 'auto',
            ),
            DropdownMenuItem(
              child: Text('English'),
              value: 'en',
            ),
            DropdownMenuItem(
              child: Text('Français'),
              value: 'fr',
            ),
            DropdownMenuItem(
              child: Text('Deutsch'),
              value: 'de',
            ),
          ],
          onChanged: (String? language) {
            if (language != null) {
              Provider.of<Language>(context, listen: false).value = language;
            }
          }),
    );
  }

  Widget _buildRegionTile(BuildContext context) {
    return ListTile(
      title: Text(NyaNyaLocalizations.of(context).regionLabel),
      trailing: DropdownButton<Regions>(
          value: Provider.of<Region>(context).value,
          items: <DropdownMenuItem<Regions>>[
            DropdownMenuItem(
              child: Text('Auto (${Region.automaticValue().label})'),
              value: Regions.auto,
            ),
            DropdownMenuItem(
              child: Text(ComputedRegions.euWest.label),
              value: Regions.euWest,
            ),
            DropdownMenuItem(
              child: Text(ComputedRegions.usEast.label),
              value: Regions.usEast,
            ),
          ],
          onChanged: (Regions? region) {
            if (region != null) {
              Provider.of<Region>(context, listen: false).value = region;
            }
          }),
    );
  }

  Widget _buildAccountManagementTile(BuildContext context, User user) {
    return ListTile(
      title: Text(NyaNyaLocalizations.of(context).accountManagementLabel),
      subtitle: Text(
          '${NyaNyaLocalizations.of(context).loginStatusLabel}: ${user.isConnected ? NyaNyaLocalizations.of(context).connectedStatusLabel : NyaNyaLocalizations.of(context).disconnectedStatusLabel}'),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return const AccountManagement();
        }));
      },
    );
  }
}
