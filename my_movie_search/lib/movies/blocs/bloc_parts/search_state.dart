part of '../search_bloc.dart';

class SearchState extends Equatable {
  const SearchState._({
    this.status = SearchStatus.awaitingInput,
    this.request = SearchRequest.empty,
  });

  const SearchState.awaitingInput() : this._();

  const SearchState.searching(SearchRequest request)
      : this._(status: SearchStatus.searching, request: request);

  const SearchState.updateResultsTic() : this._();
  const SearchState.updateResultsToc() : this._();

  const SearchState.displayingResults(List<MovieResultDTO> _results)
      : this._(status: SearchStatus.displayingResults);

  final SearchStatus status;
  final SearchRequest request;

  @override
  List<Object> get props => [status, request];
}
