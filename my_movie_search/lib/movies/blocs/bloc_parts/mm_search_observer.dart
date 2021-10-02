import 'package:bloc/bloc.dart' show BlocObserver, BlocBase, Change;

/// {@template my_movie_search_observer}
/// [BlocObserver] for the MyMovieSearch application which
/// observes all state changes.
/// {@endtemplate}
class MMSearchObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    //print('MMSearchObserver: ${bloc.runtimeType} $change');
  }
}
