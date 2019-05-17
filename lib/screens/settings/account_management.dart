import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/blocs/user.dart';
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
            title: Text('Please enter your new display name'),
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
                        return 'Between 2 and 24 characters (no space).';
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
                  child: Text('Cancel'.toUpperCase()),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              FlatButton(
                  child: Text('Confirm'.toUpperCase()),
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
                  child: Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context, false);
                  }),
              FlatButton(
                  child: Text('CONFIRM'),
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
          title: Text('Account Management'),
        ),
        body: Builder(
          builder: (innerContext) => ListView(
                children: <Widget>[
                  ListTile(
                    title: Text(
                        'Login status: ${AccountManagement.user.isConnected ? 'Connected' : 'Not Connected'}'),
                    subtitle: Text(AccountManagement.user.isConnected
                        ? 'Tap to sign-out'
                        : 'Tap to sign-in'),
                    onTap: () {
                      if (AccountManagement.user.isConnected) {
                        _showConfirmDialog(
                                context,
                                'Confirm sign-out',
                                Text(
                                    'Are you sure you want to sign-out?\n\nYou will lose the ability to publish community challenges and puzzles.'))
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
                          'Confirm sign-in',
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
                        'Display name: ${AccountManagement.user.displayName ?? "Anonymous"}'),
                    subtitle: Text('Tap to change'),
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
                                content:
                                    Text('Display name successfully changed!'),
                              ));
                            } else if (status != StatusCode.Success) {
                              if (status == StatusCode.InvalidArgument) {
                                Scaffold.of(innerContext).showSnackBar(SnackBar(
                                  content: Text(
                                      'Error: The provided display name is invalid!'),
                                ));
                              } else if (status == StatusCode.Unauthenticated) {
                                Scaffold.of(innerContext).showSnackBar(SnackBar(
                                  content: Text('Error: Unauthenticated'),
                                ));
                              }
                            }
                          });
                        }
                      });
                    },
                  ),
                  ListTile(
                    enabled: AccountManagement.user.isConnected,
                    title: Text('Account type: ' +
                        (AccountManagement.user.isAnonymous
                            ? 'Anonymous'
                            : 'Permanenent')),
                  )
                ],
              ),
        ));
  }
}
