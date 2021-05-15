import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/providers/repository.dart';
part 'bloc_parts/search_event.dart';
part 'bloc_parts/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.movieRepository})
      : super(const SearchState.awaitingInput());

  final MovieRepository movieRepository;
  StreamSubscription<MovieResultDTO>? _searchStatusSubscription;
  Map<String, MovieResultDTO> allResults = {};
  List<MovieResultDTO> sortedResults = [];

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchCompleted) {
      sortResults();
      yield SearchState.displayingResults();
    } else if (event is SearchCancelled) {
      yield SearchState.awaitingInput();
    } else if (event is SearchRequested) {
      yield SearchState.searching(SearchRequest(event.criteria.criteriaTitle));
      allResults.clear();
      sortedResults.clear();
      _searchStatusSubscription = movieRepository
          .search(event.criteria)
          .listen((dto) => receiveDTO(dto))
            ..onDone(() => add(SearchCompleted()));
    }
  }

  @override
  Future<void> close() {
    _searchStatusSubscription?.cancel();
    movieRepository.close();
    return super.close();
  }

  void receiveDTO(MovieResultDTO newValue) {
    if (newValue.uniqueId == '-1' ||
        !allResults.containsKey(newValue.uniqueId)) {
      allResults[newValue.uniqueId] = newValue;
    } else
      allResults[newValue.uniqueId]!.merge(newValue);
    add(SearchDataReceived(allResults.values.toList()));
  }

  void sortResults() {
    sortedResults.clear();
    sortedResults.addAll(allResults.values.toList());
    // Sort by relevence with recent year first
    sortedResults.sort((a, b) => b.compareTo(a));
    add(SearchDataReceived(sortedResults));
  }
}
