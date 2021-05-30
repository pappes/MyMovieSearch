import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/repository.dart';

part 'bloc_parts/search_event.dart';
part 'bloc_parts/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.movieRepository})
      : super(const SearchState.awaitingInput());

  final MovieRepository movieRepository;
  StreamSubscription<MovieResultDTO>? _searchStatusSubscription;
  Map<String, MovieResultDTO> _allResults = {};
  List<MovieResultDTO> sortedResults = [];
  double _uid = 0.0; //Unique value representing the results list contents.

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchCompleted || event is SearchDataReceived) {
      //sortResults();
      yield SearchState.displayingResults(_uid);
    } else if (event is SearchCancelled) {
      yield SearchState.awaitingInput();
    } else if (event is SearchRequested) {
      yield SearchState.searching(SearchRequest(event.criteria.criteriaTitle));
      _allResults.clear();
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
        !_allResults.containsKey(newValue.uniqueId)) {
      _allResults[newValue.uniqueId] = newValue;
    } else {
      _allResults[newValue.uniqueId]!.merge(newValue);
    }
    sortResults();
  }

  void sortResults() {
    sortedResults.clear();
    sortedResults.addAll(_allResults.values.toList());
    // Sort by relevence with recent year first
    sortedResults.sort((a, b) => b.compareTo(a));
    _uid = sortedResults.length.toDouble();
    sortedResults.forEach((element) {
      _uid += element.userRating;
    });

    add(SearchDataReceived(sortedResults));
  }
}
