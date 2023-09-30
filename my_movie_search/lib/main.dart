import 'package:bloc/bloc.dart' show Bloc;
import 'package:flutter/material.dart' show runApp;
import 'package:logger/logger.dart';
import 'package:my_movie_search/app.dart' show MMSearchApp;
import 'package:my_movie_search/movies/blocs/bloc_parts/mm_search_observer.dart';
import 'package:my_movie_search/movies/blocs/repositories/movie_search_repository.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

Future main() async {
  final settings = Settings.singleton();
  settings
      .init(logger: Logger())
      .then((_) => OnlineOfflineSelector.init(settings.get('OFFLINE')));
  Bloc.observer = MMSearchObserver();
  runApp(
    MMSearchApp(movieRepository: MovieSearchRepository()),
  );
}
