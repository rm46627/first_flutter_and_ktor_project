import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: "Sign out",
      content: "Are you sure?",
      optionsBuilder: () => {"Back": false, "Yes": true}).then((value) => value ?? false);
}
