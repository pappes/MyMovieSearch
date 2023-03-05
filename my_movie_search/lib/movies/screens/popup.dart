import 'package:flutter/material.dart';

Future<void> showPopup(BuildContext context, String dialogText) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Android Only'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              SelectableText(dialogText),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Back'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
