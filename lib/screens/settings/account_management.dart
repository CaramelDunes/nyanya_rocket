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

  Future<String> _showDialog(BuildContext context, String initialValue) {
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
                  ? AccountManagement.user.uid
                  : ''),
            ),
            ListTile(
              enabled: AccountManagement.user.isConnected,
              title: Text(
                  'Display Name: ${AccountManagement.user.displayName ?? "Anonymous"}'),
              onTap: () {
                _showDialog(context, AccountManagement.user.displayName)
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
