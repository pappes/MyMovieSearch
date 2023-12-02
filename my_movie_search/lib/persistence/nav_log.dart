import 'package:flutter/material.dart';
import 'package:my_movie_search/firebase_app_state.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:provider/provider.dart';

class NavLog extends ChangeNotifier {
  NavLog(this._context);
  final BuildContext _context;

  FirebaseApplicationState? getFirestoreProvider() =>
      Provider.of<FirebaseApplicationState>(_context, listen: false);

  void logPageOpen(String destination, String request) =>
      getFirestoreProvider()?.addRecord(
        'MMSNavLog/screen/$destination',
        id: request,
        message: ReadHistory.reading.toString(),
      );

  void logPageClose(String destination, String request, Object params) {
    if (params is MovieResultDTO &&
        params.getReadIndicator() == ReadHistory.reading.toString()) {
      getFirestoreProvider()?.addRecord(
        'MMSNavLog/screen/$destination',
        id: request,
        message: ReadHistory.read.toString(),
      );
    }
  }
}
