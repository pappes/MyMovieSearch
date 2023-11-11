import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/movies/blocs/repositories/movie_search_repository.dart';
import 'package:my_movie_search/movies/blocs/search_bloc.dart';
import 'package:my_movie_search/movies/screens/movie_search_criteria.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

/// {@template mmsearch_app}
/// A [MaterialApp] which sets the `home` to [MovieSearchCriteriaPage].
/// {@endtemplate}
class MMSearchApp extends StatelessWidget {
  /// {@macro mmsearch_app}
  const MMSearchApp({super.key, required this.movieRepository});
  final MovieSearchRepository movieRepository;

  /// Set up information for the bloc design pattern
  /// then initialise the Material application user interface.
  ///
  @override
  Widget build(BuildContext context) {
    // TODO: use bloc provider and repository provider on search screens
    return RepositoryProvider.value(
      value: movieRepository,
      child: BlocProvider(
        create: (_) => SearchBloc(movieRepository: movieRepository),
        child: MMSearchAppView(),
      ),
    );
  }
}

class MMSearchAppView extends StatefulWidget {
  @override
  _MMSearchAppViewState createState() => _MMSearchAppViewState();
}

class _MMSearchAppViewState extends State<MMSearchAppView> {
  /// Initialise the Material app with app specific settings.
  ///
  @override
  Widget build(BuildContext context) => MaterialApp.router(
        restorationScopeId: 'root',
        title: 'My Movie Search',
        routerConfig: GoRouter(
          routes: [
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
