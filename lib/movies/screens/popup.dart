import 'package:flutter/material.dart';

Future<Object?> showPopup(
  BuildContext context,
  String dialogText,
  String title, {
  List<Widget>? buttons,
}) async {
  final actions = buttons ??
      <Widget>[
        TextButton(
          child: const Text('Back'),
          onPressed: () {
            Navigator.of(context).pop('Return value goes here');
          },
        ),
      ];
  return showDialog<Object?>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            SelectableText(dialogText),
          ],
        ),
      ),
      actions: actions,
    ),
  );
}
