import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/blocs/user.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/widgets/privacy_policy_link.dart';

class AccountManagement extends StatefulWidget {
  static final User user = User();
  static final RegExp displayNameRegExp = RegExp(r'^[!-~]{2,24}$');

  @override
  _AccountManagementState createState() {
    return _AccountManagementState();
  }
}

class _AccountManagementState extends State<AccountManagement> {
  @override
  void initState() {
    super.initState();
  }

  Future<String> _showNameDialog(BuildContext context, String initialValue) {
    String displayName;
    final _formKey = GlobalKey<FormState>();

    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            title: Text(NyaNyaLocalizations.of(context).displayNameDialogTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: TextFormField(
                    autofocus: true,
                    autovalidate: true,
                    maxLength: 24,
                    initialValue: AccountManagement.user.displayName ?? '',
                    validator: (String value) {
                      if (!AccountManagement.displayNameRegExp
                          .hasMatch(value)) {
                        return NyaNyaLocalizations.of(context)
                            .displayNameFormatText;
                      }
                    },
                    onSaved: (String value) {
                      displayName = value;
                    },
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text(
                      NyaNyaLocalizations.of(context).cancel.toUpperCase()),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              FlatButton(
                  child: Text(NyaNyaLocalizations.of(context)
                      .confirmLabel
                      .toUpperCase()),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      Navigator.pop(context, displayName);
                    }
                  })
            ],
          );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(NyaNyaLocalizations.of(context).accountManagementLabel),
        ),
        body: Builder(
          builder: (innerContext) => ListView(
                children: <Widget>[
                  ListTile(
                    title: Text(
                        '${NyaNyaLocalizations.of(context).loginStatusLabel}: ${AccountManagement.user.isConnected ? NyaNyaLocalizations.of(context).connectedStatusLabel : NyaNyaLocalizations.of(context).disconnectedStatusLabel}'),
                    subtitle: Text(AccountManagement.user.isConnected
                        ? NyaNyaLocalizations.of(context).signOutLabel
                        : NyaNyaLocalizations.of(context).signInLabel),
                    onTap: () {
                      if (AccountManagement.user.isConnected) {
                        _showConfirmDialog(
                                context,
                                NyaNyaLocalizations.of(context)
                                    .signOutDialogTitle,
                                Text(NyaNyaLocalizations.of(context)
                                    .signOutDialogText))
                            .then((bool confirmed) {
                          if (confirmed != null && confirmed) {
                            AccountManagement.user.signOut().then((void _) {
                              setState(() {});
                            });
                          }
                        });
                      } else {
                        _showConfirmDialog(
                          context,
                          NyaNyaLocalizations.of(context).signInDialogTitle,
                          const PrivacyPolicyLink(),
                        ).then((bool confirmed) {
                          if (confirmed != null && confirmed) {
                            AccountManagement.user
                                .signInAnonymously()
                                .then((void _) {
                              setState(() {});
                            });
                          }
                        });
                      }
                    },
                  ),
                  ListTile(
                    enabled: AccountManagement.user.isConnected,
                    title: Text(
                        '${NyaNyaLocalizations.of(context).displayNameLabel}: ${AccountManagement.user.displayName ?? ''}'),
                    subtitle: Text(NyaNyaLocalizations.of(context)
                        .tapToChangeDisplayNameLabel),
                    onTap: () {
                      _showNameDialog(
                              context, AccountManagement.user.displayName)
                          .then((String displayName) {
                        if (displayName != null) {
                          AccountManagement.user
                              .setDisplayName(displayName)
                              .then((StatusCode status) {
                            if (mounted && status == StatusCode.Success) {
                              setState(() {});
                              Scaffold.of(innerContext).showSnackBar(SnackBar(
                                content: Text(NyaNyaLocalizations.of(context)
                                    .displayNameChangeSuccessText),
                              ));
                            } else if (status != StatusCode.Success) {
                              if (status == StatusCode.InvalidArgument) {
                                Scaffold.of(innerContext).showSnackBar(SnackBar(
                                  content: Text(NyaNyaLocalizations.of(context)
                                      .invalidDisplayNameError),
                                ));
                              } else if (status == StatusCode.Unauthenticated) {
                                Scaffold.of(innerContext).showSnackBar(SnackBar(
                                  content: Text(NyaNyaLocalizations.of(context)
                                      .unauthenticatedError),
                                ));
                              }
                            }
                          });
                        }
                      });
                    },
                  )
                ],
              ),
        ));
  }
}
