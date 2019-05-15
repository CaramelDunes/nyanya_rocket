import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/blocs/user.dart';

class AccountManagement extends StatefulWidget {
  static final User user = User();

  @override
  AccountManagementState createState() {
    return AccountManagementState();
  }
}

class AccountManagementState extends State<AccountManagement> {
  @override
  void initState() {
    super.initState();
  }

  Future<String> _showNameDialog(BuildContext context, String initialValue) {
    String displayName;

    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            title: Text('Please enter your new display name'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: TextEditingController.fromValue(TextEditingValue(
                      text: AccountManagement.user.displayName,
                      selection: TextSelection(
                          baseOffset: 0,
                          extentOffset:
                              AccountManagement.user.displayName.length))),
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'New display name',
                  ),
                  onChanged: (String value) => displayName = value,
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
                    Navigator.pop(context, displayName);
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
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                  'Login Status: ${AccountManagement.user.isConnected ? 'Connected' : 'Not Connected'}'),
              subtitle: Text(AccountManagement.user.isConnected
                  ? 'Tap to sign-out'
                  : 'Tap to sign-in'),
              onTap: () {
                if (AccountManagement.user.isConnected) {
                  _showConfirmDialog(
                          context,
                          'Confirm sign-out',
                          Text(
                              'Are you sure you want to sign-out?\n\nIt won\'t be possible to go back and you will lose the ability to publish community challenges and puzzles.'))
                      .then((bool confirmed) {
                    if (confirmed != null && confirmed) {
                      AccountManagement.user.signOut().then((void _) {
                        setState(() {});
                      });
                    }
                  });
                } else {
                  _showConfirmDialog(context, 'Confirm sign-in', Text(''))
                      .then((bool confirmed) {
                    if (confirmed != null && confirmed) {
                      AccountManagement.user.signInAnonymously().then((void _) {
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
                  'Display Name: ${AccountManagement.user.displayName ?? "Anonymous"}'),
              onTap: () {
                _showNameDialog(context, AccountManagement.user.displayName)
                    .then((String displayName) {
                  if (displayName != null) {
                    AccountManagement.user
                        .setDisplayName(displayName)
                        .then((void _) {
                      if (mounted) {
                        setState(() {});
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
//                subtitle: Text('Tap to link'),
            )
          ],
        ));
  }
}
