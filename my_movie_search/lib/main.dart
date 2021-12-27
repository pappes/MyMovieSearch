import 'package:bloc/bloc.dart' show BlocOverrides;
import 'package:flutter/material.dart' show runApp;

import 'package:my_movie_search/app.dart' show MMSearchApp;
import 'package:my_movie_search/movies/blocs/bloc_parts/mm_search_observer.dart';
import 'package:my_movie_search/movies/blocs/repositories/movie_search_repository.dart';
import 'package:my_movie_search/utilities/environment.dart'
    show EnvironmentVars;
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

Future main() async {
  EnvironmentVars.init().then(
    (env) => OnlineOfflineSelector.init(env["OFFLINE"]),
  );

  BlocOverrides.runZoned(
    () {
      runApp(
        MMSearchApp(movieRepository: MovieSearchRepository()),
      );
    },
    blocObserver: MMSearchObserver(),
  );
}
