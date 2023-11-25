import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:my_movie_search/app.dart';
import 'package:my_movie_search/firebase_app_state.dart';
import 'package:my_movie_search/movies/blocs/bloc_parts/mm_search_observer.dart';
import 'package:my_movie_search/movies/blocs/repositories/movie_search_repository.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  final settings = Settings.singleton();

  WidgetsFlutterBinding.ensureInitialized();

  unawaited(
    settings
        .init(logger: Logger())
        .then((_) => OnlineOfflineSelector.init(settings.get('OFFLINE'))),
  );
  Bloc.observer = MMSearchObserver();
  unawaited(FirebaseApplicationState().login());

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  runApp(
    ChangeNotifierProvider<FirebaseApplicationState>(
      create: (_) => FirebaseApplicationState(),
      builder: (_, __) =>
          MMSearchApp(overrideBlocRepository: MovieSearchRepository()),
    ),
  );
}
