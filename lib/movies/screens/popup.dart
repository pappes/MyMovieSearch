import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Displays a popup dialog with the given text and title.
///
/// @param context The build context of the widget.
/// @param dialogText The text to display in the dialog.
/// @param title The title of the dialog.
/// @param buttons The buttons to display in the dialog.
///
/// @returns The result of the dialog.
Future<Object?> showPopup(
  BuildContext context,
  String dialogText,
  String title, {
  List<Widget>? buttons,
}) {
  final actions =
      buttons ??
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
        child: ListBody(children: <Widget>[SelectableText(dialogText)]),
      ),
      actions: actions,
    ),
  );
}

/// Displays a popup dialog with the given text and title.
///
/// @param context The build context of the widget.
/// @param dialogText The defaulttext to display in the dialog.
/// @param title The title of the dialog.
///
/// @returns The text the user entered.
Future<String?> showInputPopup(
  BuildContext context,
  String dialogText,
  String title,
) {
  final controller = TextEditingController(text: dialogText);
  // Helper function to submit data consistently
  void submit() {
    Navigator.of(context).pop(controller.text);
  }

  // Helper function to cancel consistently
  void cancel() {
    Navigator.of(context).pop();
  }

  final actions = <Widget>[
    TextButton(onPressed: submit, child: const Text('Ok')),
    TextButton(onPressed: cancel, child: const Text('Cancel')),
  ];
  return showDialog<String?>(
    context: context,
    builder: (context) => KeyboardListener(
      // FocusNode is required; an internal one keeps it scoped to the dialog
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (event) {
        // We only want to trigger the action once per key press (on key down)
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            submit();
          } /*else if (event.logicalKey == LogicalKeyboardKey.escape) {
            cancel();
          }*/
        }
      },
      child: AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          // Triggering 'OK' when pressing Enter on mobile soft-keyboards too
          onSubmitted: (_) => submit(),
          decoration: const InputDecoration(hintText: 'Movie name.'),
        ),
        actions: actions,
      ),
    ),
  );
}
