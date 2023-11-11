import 'package:flutter/material.dart';
import 'package:my_movie_search/firebase_app_state.dart';
import 'package:provider/provider.dart';

class NavLog extends ChangeNotifier {
  NavLog(this._context);
  final BuildContext _context;

  FirebaseApplicationState? getFirestoreProvider() =>
      Provider.of<FirebaseApplicationState>(_context, listen: false);

  void log(String destination, String request) => getFirestoreProvider()
      ?.addRecord('MMSNavLog/screen/$destination', id: request);
}
