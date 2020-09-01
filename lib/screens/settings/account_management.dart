import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/user.dart';
import 'package:nyanya_rocket/screens/privacy_policy_prompt/privacy_policy_prompt.dart';
import 'package:nyanya_rocket/screens/settings/widgets/display_name_change_dialog.dart';
import 'package:provider/provider.dart';

import 'widgets/sign_up_dialog.dart';

class AccountManagement extends StatelessWidget {
  static final RegExp displayNameRegExp = RegExp(r'^[!-~]{2,24}$');

  Future<String> _showNameDialog(BuildContext context, String initialValue) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return DisplayNameChangeDialog(
              initialValue: initialValue,
              user: Provider.of<User>(context, listen: false));
        });
  }

  Future<bool> _showConfirmDialog(
      BuildContext context, String title, Widget content) {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: content,
            actions: <Widget>[
              FlatButton(
                  child: Text(
                      NyaNyaLocalizations.of(context).cancel.toUpperCase()),
                  onPressed: () {
                    Navigator.pop(context, false);
                  }),
              FlatButton(
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
      title: Text(
          '${NyaNyaLocalizations.of(context).displayNameLabel}: ${user.displayName ?? ''}'),
      subtitle:
          Text(NyaNyaLocalizations.of(context).tapToChangeDisplayNameLabel),
      onTap: () {
        _showNameDialog(context, user.displayName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(NyaNyaLocalizations.of(context).accountManagementLabel),
      ),
      body: Consumer<User>(
        builder: (innerContext, user, _) => ListView(
          children: <Widget>[
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
                          Text(NyaNyaLocalizations.of(context)
                              .signOutDialogText))
                      .then((bool confirmed) {
                    if (confirmed ?? false) {
                      user.signOut();
                    }
                  });
                } else {
                  promptSignUp(context);
                }
              },
            ),
            _buildDisplayNameTile(innerContext, user),
            ListTile(
              title: Text(NyaNyaLocalizations.of(context).privacyPolicyLabel),
              onTap: () {
                Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PrivacyPolicyPrompt(askUser: false)));
              },
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool> promptSignUp(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return SignUpDialog(user: Provider.of<User>(context, listen: false));
        });
  }
}
