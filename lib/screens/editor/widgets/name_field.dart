import 'package:flutter/material.dart';
import 'package:nyanya_rocket/localization/nyanya_localizations.dart';
import 'package:nyanya_rocket/screens/editor/widgets/create_tab.dart';

class NameFormField extends StatelessWidget {
  final FormFieldSetter<String> onSaved;

  const NameFormField({Key? key, required this.onSaved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      autovalidateMode: AutovalidateMode.always,
      textCapitalization: TextCapitalization.words,
      maxLength: 24,
      decoration: InputDecoration(
        labelText: NyaNyaLocalizations.of(context).nameLabel,
      ),
      onSaved: onSaved,
      validator: (String? value) {
        if (value == null || !CreateTab.nameRegExp.hasMatch(value)) {
          return NyaNyaLocalizations.of(context).invalidNameText;
        }

        return null;
      },
    );
  }
}
