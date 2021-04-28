import 'package:flutter/material.dart';

import 'package:my_movie_search/app.dart';
import 'package:my_movie_search/movies/providers/repository.dart';

import 'package:my_movie_search/utilities/environment.dart';
import 'package:my_movie_search/utilities/online_offline_search.dart';

import 'package:bloc/bloc.dart';
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
