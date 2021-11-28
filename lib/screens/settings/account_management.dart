import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import 'widgets/sign_up_dialog.dart';

abstract class AccountManagement {
  static final RegExp displayNameRegExp = RegExp(r'^[!-~]{2,24}$');

  static Future<bool?> promptSignUp(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return SignUpDialog(user: Provider.of<User>(context, listen: false));
        });
  }
}
