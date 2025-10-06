import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:my_movie_search/app.dart';
import 'package:my_movie_search/movies/blocs/bloc_parts/mm_search_observer.dart';
import 'package:my_movie_search/movies/blocs/repositories/movie_search_repository.dart';
import 'package:my_movie_search/movies/models/movie_location.dart';
import 'package:my_movie_search/persistence/firebase/firebase_common.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Settings().init(Logger());
  OnlineOfflineSelector.init(Settings().offline);

  Bloc.observer = MMSearchObserver();
  unawaited(
    FirebaseApplicationState().login().then((_) => MovieLocation().init()),
  );

  runApp(
    ChangeNotifierProvider<FirebaseApplicationState>(
      create: (_) => FirebaseApplicationState(),
      builder:
          (_, __) => MMSearchApp(movieBlocRepository: MovieSearchRepository()),
    ),
  );
}
