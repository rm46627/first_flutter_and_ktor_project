import 'package:flutter/cupertino.dart';
import 'package:mynotes/assets/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
      context: context,
      title: "Error occurred.",
      content: text,
      optionsBuilder: () => {
            "Ok": null,
          });
}
