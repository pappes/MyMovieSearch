import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/movies/blocs/repositories/movie_search_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/repository_types/base_movie_repository.dart';
import 'package:my_movie_search/movies/blocs/search_bloc.dart';
import 'package:my_movie_search/movies/screens/movie_search_criteria.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

/// {@template mmsearch_app}
/// A [MaterialApp] which sets the `home` to [MovieSearchCriteriaPage].
///
/// [_blocRepository] can be overridden
/// to provide an alternate datasource for mocking
/// {@endtemplate}
class MMSearchApp extends StatelessWidget {
  /// {@macro mmsearch_app}
  MMSearchApp({BaseMovieRepository? movieBlocRepository, super.key})
      : _blocRepository = movieBlocRepository ?? MovieSearchRepository();

  final BaseMovieRepository _blocRepository;

  /// Set up information for the bloc design pattern
  /// then initialise the Material application user interface.
  ///

  // TODO(pappes): Use bloc provider and repository provider on search screens. https://github.com/pappes/MyMovieSearch/issues/69
  @override
  Widget build(BuildContext context) =>
      RepositoryProvider<BaseMovieRepository>.value(
        value: _blocRepository,
        child: BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(
            movieRepository: _blocRepository,
          ),
          child: const _MMSearchAppView(),
        ),
      );
}

class _MMSearchAppView extends StatefulWidget {
  const _MMSearchAppView();

  @override
  State<_MMSearchAppView> createState() => _MMSearchAppViewState();
}

class _MMSearchAppViewState extends State<_MMSearchAppView>
    with RestorationMixin {
  /// Initialise the Material app with app specific settings.
  ///

  @override
  String get restorationId => '_MMSearchAppViewState';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {}

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        restorationScopeId: 'MyMovieSearch',
        title: 'My Movie Search',
        routerConfig: GoRouter(
          restorationScopeId: 'router',
          routes: <RouteBase>[
            ...MMSNav.getRoutes(),
            //...FirebaseApplicationState().getRoutes(),
          ],
        ),
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          fontFamily: 'Lato',
        ),
        darkTheme: ThemeData(brightness: Brightness.dark),
      );
}
