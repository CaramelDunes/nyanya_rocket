import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/privacy_policy_prompt/privacy_policy_prompt.dart';

import '../account_management.dart';
import '../../../models/user.dart';

class SignUpDialog extends StatefulWidget {
  final User user;

  const SignUpDialog({super.key, required this.user});

  @override
  State<SignUpDialog> createState() => _SignUpDialogState();
}

class _SignUpDialogState extends State<SignUpDialog> {
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
                const SizedBox(height: 8.0),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                          text: NyaNyaLocalizations.of(context)
                              .privacyPolicySignUpText),
                      TextSpan(
                          text: NyaNyaLocalizations.of(context)
                              .privacyPolicyLabel,
                          style: const TextStyle(
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
      actions: [
        if (!_loading)
          TextButton(
              child: Text(
                  NyaNyaLocalizations.of(context).confirmLabel.toUpperCase()),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  setState(() {
                    _loading = true;
                  });

                  widget.user.signInAnonymously().then((success) {
                    widget.user.setDisplayName(_displayName!);
                    Navigator.pop(context, true);
                  }).catchError((e) {
                    setState(() {
                      _loading = false;
                    });
                  });
                }
              }),
        TextButton(
            child: Text(NyaNyaLocalizations.of(context).cancel.toUpperCase()),
            onPressed: () {
              Navigator.pop(context, false);
            }),
      ],
    );
  }
}
