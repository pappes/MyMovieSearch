part of '../search_bloc.dart';

class SearchState extends Equatable {
  const SearchState._({
    this.status = SearchStatus.awaitingInput,
    this.request = SearchRequest.empty,
    this.result = const [],
  });

  const SearchState.awaitingInput() : this._();

  const SearchState.searching(SearchRequest request)
      : this._(status: SearchStatus.searching, request: request);

  const SearchState.displayingResults()
      : this._(status: SearchStatus.displayingResults);

  final SearchStatus status;
  final SearchRequest request;
  final List<MovieResultDTO> result;

  @override
  List<Object> get props => [status, request];
}
