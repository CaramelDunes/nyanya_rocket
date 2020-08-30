import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/user.dart';
import 'package:nyanya_rocket/screens/privacy_policy_prompt/privacy_policy_prompt.dart';
import 'package:provider/provider.dart';

class AccountManagement extends StatelessWidget {
  static final RegExp displayNameRegExp = RegExp(r'^[!-~]{2,24}$');

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
                    initialValue: initialValue,
                    validator: (String value) {
                      if (!AccountManagement.displayNameRegExp
                          .hasMatch(value)) {
                        return NyaNyaLocalizations.of(context)
                            .displayNameFormatText;
                      }

                      return null;
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

  Widget _buildDisplayNameTile(BuildContext context, User user) {
    return ListTile(
      enabled: user.isConnected,
      title: Text(
          '${NyaNyaLocalizations.of(context).displayNameLabel}: ${user.displayName ?? ''}'),
      subtitle:
          Text(NyaNyaLocalizations.of(context).tapToChangeDisplayNameLabel),
      onTap: () {
        _showNameDialog(context, user.displayName).then((String displayName) {
          if (displayName != null) {
            user.setDisplayName(displayName).then((StatusCode status) {
              if (status == StatusCode.Success) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(NyaNyaLocalizations.of(context)
                      .displayNameChangeSuccessText),
                ));
              } else {
                if (status == StatusCode.InvalidArgument) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(NyaNyaLocalizations.of(context)
                        .invalidDisplayNameError),
                  ));
                } else if (status == StatusCode.Unauthenticated) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                        NyaNyaLocalizations.of(context).unauthenticatedError),
                  ));
                }
              }
            });
          }
        });
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
    String displayName;
    final _formKey = GlobalKey<FormState>();

    return showDialog<bool>(
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
                    validator: (String value) {
                      if (!AccountManagement.displayNameRegExp
                          .hasMatch(value)) {
                        return NyaNyaLocalizations.of(context)
                            .displayNameFormatText;
                      }

                      return null;
                    },
                    onSaved: (String value) {
                      displayName = value;
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    children: <TextSpan>[
                      TextSpan(
                          text: NyaNyaLocalizations.of(context)
                              .privacyPolicySignUpText),
                      TextSpan(
                          text: NyaNyaLocalizations.of(context)
                              .privacyPolicyLabel,
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const PrivacyPolicyPrompt(
                                              askUser: false)));
                            })
                    ],
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text(NyaNyaLocalizations.of(context)
                      .confirmLabel
                      .toUpperCase()),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      Navigator.pop(context, true);

                      Provider.of<User>(context, listen: false)
                          .signInAnonymously()
                          .then((user) {
                        user.updateProfile(displayName: displayName);
                      });
                    }
                  }),
              FlatButton(
                  child: Text(
                      NyaNyaLocalizations.of(context).cancel.toUpperCase()),
                  onPressed: () {
                    Navigator.pop(context, false);
                  }),
            ],
          );
        });
  }
}
