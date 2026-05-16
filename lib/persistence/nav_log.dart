
import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/persistence/firebase/firebase_common.dart';
import 'package:my_movie_search/persistence/session_nav_tree.dart';
import 'package:provider/provider.dart';

class NavLog extends ChangeNotifier {
  NavLog(this._context);
  final BuildContext? _context;

  static const String rootReference = 'root';

  FirebaseApplicationState? getFirestoreProvider() =>
      (_context == null || !_context.mounted)
      ? null
      : Provider.of<FirebaseApplicationState>(_context, listen: false);

  SessionNavTree? getSessionNavTree() => (_context == null || !_context.mounted)
      ? null
      : Provider.of<SessionNavTree>(_context, listen: false);

  void logPageOpen(String destination, String request) {
    getFirestoreProvider()?.addRecord(
      'MMSNavLog/screen/$destination',
      id: request,
        message: ReadHistory.reading.toString(),
      );
    getSessionNavTree()?.logPageOpen(destination, request);
  }

  void logPageClose(String destination, String request, Object params) {
    if (params is MovieResultDTO &&
        params.getReadIndicator() == ReadHistory.reading.toString()) {
      
      getFirestoreProvider()?.addRecord(
        'MMSNavLog/screen/$destination',
        id: request,
        message: ReadHistory.read.toString(),
      );
    }
    getSessionNavTree()?.logPageClose(destination, request);
  }
}
