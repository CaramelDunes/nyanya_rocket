import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config.dart';
import '../../localization/nyanya_localizations.dart';
import '../../models/user.dart';
import '../privacy_policy_prompt/privacy_policy_prompt.dart';
import 'account_management.dart';
import 'brightness_setting.dart';
import 'language.dart';
import 'region.dart';
import 'widgets/display_name_change_dialog.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    const EdgeInsets sectionInsets = EdgeInsets.only(top: 8.0, left: 8.0);
    final TextStyle? sectionStyle = Theme.of(context).textTheme.headlineSmall;

    return Scaffold(
        appBar: AppBar(
          title: Text(NyaNyaLocalizations.of(context).settingsTitle),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: kMaxWidthForBigScreens),
              child: ListView(
                children: [
                  Padding(
                    padding: sectionInsets,
                    child: Text(
                      NyaNyaLocalizations.of(context).generalLabel,
                      style: sectionStyle,
                    ),
                  ),
                  Consumer<BrightnessSetting>(
                      builder: (context, brightnessSetting, _) =>
                          _buildBrightnessTile(context, brightnessSetting)),
                  Consumer<Language>(
                      builder: (context, language, _) =>
                          _buildLanguageTile(context, language)),
                  Consumer<Region>(
                      builder: (context, region, _) =>
                          _buildRegionTile(context, region)),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: sectionInsets,
                    child: Text(
                      NyaNyaLocalizations.of(context).accountManagementLabel,
                      style: sectionStyle,
                    ),
                  ),
                  Consumer<User>(
                    builder: (context, user, _) =>
                        _buildAccountManagementTile(context, user),
                  ),
                  const SizedBox(height: 16.0),
                  AboutListTile(
                    applicationLegalese: kAboutText,
                    applicationVersion: kAboutVersion,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildBrightnessTile(
      BuildContext context, BrightnessSetting brightnessSetting) {
    return ListTile(
      title: Text(NyaNyaLocalizations.of(context).themeModeLabel),
      trailing: DropdownButton<ThemeMode>(
          value: brightnessSetting.value,
          items: <DropdownMenuItem<ThemeMode>>[
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text(BrightnessSetting.automaticValueLabel(context)),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text(Brightness.light.toLocalizedString(context)),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text(Brightness.dark.toLocalizedString(context)),
            ),
          ],
          onChanged: (ThemeMode? newMode) {
            if (newMode != null) {
              brightnessSetting.value = newMode;
            }
          }),
    );
  }

  Widget _buildLanguageTile(BuildContext context, Language language) {
    return ListTile(
      title: Text(NyaNyaLocalizations.of(context).languageLabel),
      trailing: DropdownButton<String>(
          value: language.value,
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem(
              value: 'auto',
              child: Text('Auto'),
            ),
            DropdownMenuItem(
              value: 'en',
              child: Text('English'),
            ),
            DropdownMenuItem(
              value: 'fr',
              child: Text('Français'),
            ),
            DropdownMenuItem(
              value: 'de',
              child: Text('Deutsch'),
            ),
          ],
          onChanged: (String? newLanguage) {
            if (newLanguage != null) {
              language.value = newLanguage;
            }
          }),
    );
  }

  Widget _buildRegionTile(BuildContext context, Region region) {
    return ListTile(
      title: Text(NyaNyaLocalizations.of(context).regionLabel),
      trailing: DropdownButton<Regions>(
          value: region.value,
          items: <DropdownMenuItem<Regions>>[
            DropdownMenuItem(
              value: Regions.auto,
              child: Text('Auto (${Region.automaticValue().label})'),
            ),
            DropdownMenuItem(
              value: Regions.euWest,
              child: Text(ComputedRegions.euWest.label),
            ),
            DropdownMenuItem(
              value: Regions.usEast,
              child: Text(ComputedRegions.usEast.label),
            ),
          ],
          onChanged: (Regions? newRegion) {
            if (newRegion != null) {
              region.value = newRegion;
            }
          }),
    );
  }

  Widget _buildAccountManagementTile(BuildContext context, User user) {
    return Column(children: [
      ListTile(
        title: Text(
            '${NyaNyaLocalizations.of(context).loginStatusLabel}: ${user.isConnected ? NyaNyaLocalizations.of(context).connectedStatusLabel : NyaNyaLocalizations.of(context).disconnectedStatusLabel}'),
        subtitle: Text(user.isConnected
            ? NyaNyaLocalizations.of(context).signOutLabel
            : NyaNyaLocalizations.of(context).signInLabel),
        onTap: () {
          if (user.isConnected) {
            _showConfirmDialog(
                    context,
                    NyaNyaLocalizations.of(context).signOutDialogTitle,
                    Text(NyaNyaLocalizations.of(context).signOutDialogText))
                .then((bool? confirmed) {
              if (confirmed ?? false) {
                user.signOut();
              }
            });
          } else {
            AccountManagement.promptSignUp(context);
          }
        },
      ),
      _buildDisplayNameTile(context, user),
      ListTile(
        title: Text(NyaNyaLocalizations.of(context).privacyPolicyLabel),
        onTap: () {
          Navigator.push<bool>(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      const PrivacyPolicyPrompt(askUser: false)));
        },
      ),
    ]);
  }

  Future<String?> _showNameDialog(
      BuildContext context, String? initialValue, User user) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return DisplayNameChangeDialog(
              initialValue: initialValue, user: user);
        });
  }

  Future<bool?> _showConfirmDialog(
      BuildContext context, String title, Widget content) {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: content,
            actions: [
              TextButton(
                  child: Text(
                      NyaNyaLocalizations.of(context).cancel.toUpperCase()),
                  onPressed: () {
                    Navigator.pop(context, false);
                  }),
              TextButton(
                  child: Text(NyaNyaLocalizations.of(context)
                      .confirmLabel
                      .toUpperCase()),
                  onPressed: () {
                    Navigator.pop(context, true);
                  })
            ],
          );
        });
  }

  Widget _buildDisplayNameTile(BuildContext context, User user) {
    return ListTile(
      enabled: user.isConnected,
      title: Text(user.displayName != null
          ? '${NyaNyaLocalizations.of(context).displayNameLabel}: ${user.displayName}'
          : NyaNyaLocalizations.of(context).noDisplayNameLabel),
      subtitle:
          Text(NyaNyaLocalizations.of(context).tapToChangeDisplayNameLabel),
      onTap: () {
        _showNameDialog(context, user.displayName, user);
      },
    );
  }
}
