import 'package:bloc/bloc.dart';

/// {@template my_movie_search_observer}
/// [BlocObserver] for the MyMovieSearch application which
/// observes all state changes.
/// {@endtemplate}
class MMSearchObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    //print('MMSearchObserver: ${bloc.runtimeType} $change');
  }
}
