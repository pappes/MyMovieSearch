import 'package:flutter/material.dart' show runApp;

import 'package:bloc/bloc.dart' show Bloc;

import 'package:my_movie_search/app.dart' show MMSearchApp;
import 'package:my_movie_search/utilities/environment.dart'
    show EnvironmentVars;
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

import 'movies/web_data_providers/repository.dart';
import 'movies/blocs/bloc_parts/mm_search_observer.dart';

Future main() async {
  EnvironmentVars.init().then(
    (env) => OnlineOfflineSelector.init(env["OFFLINE"]),
  );

  Bloc.observer = MMSearchObserver();

  runApp(
    MMSearchApp(movieRepository: MovieRepository()),
  );
}
