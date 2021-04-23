import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie_search/movies/providers/repository.dart';

/*class BusinessLogicMovieSearch extends Bloc<MyEvent, MyState> {
    final MovieRepository repository;

    Stream mapEventToState(event) async* {
        if (event is AppStarted) {
            try {
                final data = await repository.search();
                yield Success(data);
            } catch (error) {
                yield Failure(error);
            }
        }
    }
}*/
