import 'package:flutter/material.dart';
import 'package:mynotes/assets/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: "Delete action",
      content: "Are you sure you want to continue the action?",
      optionsBuilder: () => {"Back": false, "Yes": true}).then((value) => value ?? false);
}
