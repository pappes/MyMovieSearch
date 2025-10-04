import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/persistence/firebase/firebase_common.dart';
import 'package:provider/provider.dart';

class NavLog extends ChangeNotifier {
  NavLog(this._context);
  final BuildContext? _context;

  FirebaseApplicationState? getFirestoreProvider() =>
      (_context==null || !_context.mounted) ? 
        null : 
        Provider.of<FirebaseApplicationState>(_context, listen: false);

  void logPageOpen(String destination, String request) => unawaited(
        getFirestoreProvider()?.addRecord(
          'MMSNavLog/screen/$destination',
          id: request,
          message: ReadHistory.reading.toString(),
        ),
      );

  void logPageClose(String destination, String request, Object params) {
    if (params is MovieResultDTO &&
        params.getReadIndicator() == ReadHistory.reading.toString()) {
      unawaited(
        getFirestoreProvider()?.addRecord(
          'MMSNavLog/screen/$destination',
          id: request,
          message: ReadHistory.read.toString(),
        ),
      );
    }
  }
}
