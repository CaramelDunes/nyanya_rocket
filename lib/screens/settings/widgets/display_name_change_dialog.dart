import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/models/user.dart';

import '../account_management.dart';

class DisplayNameChangeDialog extends StatefulWidget {
  final String? initialValue;
  final User user;

  const DisplayNameChangeDialog(
      {Key? key, required this.initialValue, required this.user})
      : super(key: key);

  @override
  _DisplayNameChangeDialogState createState() =>
      _DisplayNameChangeDialogState();
}

class _DisplayNameChangeDialogState extends State<DisplayNameChangeDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _displayName;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      title: Text(NyaNyaLocalizations.of(context).displayNameDialogTitle),
      content: _loading
          ? const Center(
              widthFactor: 1,
              heightFactor: 1,
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.always,
                    maxLength: 24,
                    initialValue: widget.initialValue,
                    validator: (String? value) {
                      if (value == null ||
                          !AccountManagement.displayNameRegExp
                              .hasMatch(value)) {
                        return NyaNyaLocalizations.of(context)
                            .displayNameFormatText;
                      }

                      return null;
                    },
                    onSaved: (String? value) {
                      _displayName = value;
                    },
                  ),
                ),
              ],
            ),
      actions: [
        TextButton(
            child: Text(NyaNyaLocalizations.of(context).cancel.toUpperCase()),
            onPressed: () {
              Navigator.pop(context);
            }),
        if (!_loading)
          TextButton(
              child: Text(
                  NyaNyaLocalizations.of(context).confirmLabel.toUpperCase()),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  if (_displayName != null) {
                    setState(() {
                      _loading = true;
                    });

                    widget.user.setDisplayName(_displayName!).then((success) {
                      if (success) {
                        Navigator.pop(context, _displayName);
                      } else {
                        setState(() {
                          _loading = false;
                        });
                      }
                    });
                  }
                }
              })
      ],
    );
  }
}
