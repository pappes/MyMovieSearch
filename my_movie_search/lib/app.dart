import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie_search/movies/providers/repository.dart';
import 'package:my_movie_search/movies/blocs/search_bloc.dart';
//import 'package:my_movie_search/screens/home.dart';
import 'package:my_movie_search/movies/screens/movie_search_criteria.dart';
//import 'package:my_movie_search/screens/webveiw/webview_testing.dart';

//class MyApp extends MaterialApp {

/// {@template counter_app}
/// A [MaterialApp] which sets the `home` to [MovieSearchCriteriaPage].
/// {@endtemplate}
class MMSearchApp extends StatelessWidget {
  /// {@macro counter_app}
  const MMSearchApp({Key? key, required this.movieRepository})
      : super(
          key: key,
          //home: const MovieSearchCriteriaPage(movieRepository),
          //   home: MovieHomePage(),
          //title: 'My Movie Search',
          //theme: ThemeData(brightness: Brightness.light),
          //darkTheme: ThemeData(brightness: Brightness.dark),
          //themeMode: ThemeMode.system, //dark or light or system
        );
  final MovieRepository movieRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: movieRepository,
      child: BlocProvider(
        create: (_) => SearchBloc(movieRepository: movieRepository),
        child: AppView(),
      ),
    );
  }
}
// This widget is the root of your application.
/*@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Movie Search',
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system, //dark or light or system
      home: MovieSearchCriteriaPage(),
      //   home: MovieHomePage(),
    );
  }*/
//}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
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
      },
      onGenerateRoute: (_) => MovieSearchCriteriaPage.route(),
    );
  }
}
