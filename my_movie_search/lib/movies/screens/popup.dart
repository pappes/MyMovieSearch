import 'package:flutter/material.dart';

Future<void> showPopup(
  BuildContext context,
  String dialogText,
  String title,
) async =>
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
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
      ),
    );
