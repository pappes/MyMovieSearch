import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_movie_search/app.dart';
import 'package:my_movie_search/firebase_app_state.dart';
import 'package:my_movie_search/movies/blocs/bloc_parts/mm_search_observer.dart';
import 'package:my_movie_search/movies/blocs/repositories/movie_search_repository.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:provider/provider.dart';

Future main() async {
  final settings = Settings.singleton();

  WidgetsFlutterBinding.ensureInitialized();

  settings
      .init(logger: Logger())
      .then((_) => OnlineOfflineSelector.init(settings.get('OFFLINE')));
  Bloc.observer = MMSearchObserver();
  FirebaseApplicationState().login();

  runApp(
    ChangeNotifierProvider(
      create: (context) => FirebaseApplicationState(),
      builder: (context, child) =>
          MMSearchApp(movieRepository: MovieSearchRepository()),
    ),
  );
}
