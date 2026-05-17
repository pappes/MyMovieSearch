
import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/persistence/firebase/firebase_common.dart';
import 'package:my_movie_search/persistence/session_nav_tree.dart';
import 'package:provider/provider.dart';
import 'package:my_movie_search/utilities/navigation/route_info.dart';
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

  void logPageOpen(RouteInfo route) {
    getFirestoreProvider()?.addRecord(
      'MMSNavLog/screen/${route.routePath.name}',
      id: route.reference,
        message: ReadHistory.reading.toString(),
      );
    getSessionNavTree()?.logPageOpen(route);
  }

  void logPageClose(RouteInfo route) {
    if (route.params is MovieResultDTO &&
        (route.params as MovieResultDTO).getReadIndicator() == ReadHistory.reading.toString()) {
      
      getFirestoreProvider()?.addRecord(
        'MMSNavLog/screen/${route.routePath.name}',
        id: route.reference,
        message: ReadHistory.read.toString(),
      );
    }
    getSessionNavTree()?.logPageClose(route);
  }
}
