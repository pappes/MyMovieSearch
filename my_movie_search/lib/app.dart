import 'dart:ui';

import 'package:flutter/material.dart'
    show
        BuildContext,
        GlobalKey,
        Key,
        MaterialApp,
        NavigatorState,
        State,
        StatefulWidget,
        StatelessWidget,
        ThemeData,
        Widget;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'movies/blocs/repositories/movie_search_repository.dart';
import 'movies/blocs/search_bloc.dart';
import 'movies/screens/movie_search_criteria.dart';

/// {@template mmsearch_app}
/// A [MaterialApp] which sets the `home` to [MovieSearchCriteriaPage].
/// {@endtemplate}
class MMSearchApp extends StatelessWidget {
  /// {@macro mmsearch_app}
  const MMSearchApp({Key? key, required this.movieRepository})
      : super(
          key: key,
        );
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
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  //NavigatorState get _navigator => _navigatorKey.currentState!;

  /// Initialise the Material app with app specific settings.
  ///
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'root',
      navigatorKey: _navigatorKey,
      //home: const MovieSearchCriteriaPage(movieRepository),
      //   home: MovieHomePage(),
      home: const MovieSearchCriteriaPage(),
      //onGenerateRoute: (_) => MovieSearchCriteriaPage.route(),
      title: 'My Movie Search',
      theme: ThemeData(
        //brightness: Brightness.light,
        fontFamily: 'Lato',
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      //themeMode: ThemeMode.system, //dark or light or system
      /*builder: (context, child) {
        return BlocListener<SearchBloc, SearchState>(
          listener: (context, state) {
            switch (state.status) {
              /*case SearchStatus.searching:
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                  (route) => false,
                );
                break;
              case SearchStatus.awaitingInput:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
                break;*/
              default:
                break;
            }
          },
          child: child,
        );
      },*/
    );
  }
}
