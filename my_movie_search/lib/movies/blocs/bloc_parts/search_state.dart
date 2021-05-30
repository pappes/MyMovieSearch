part of '../search_bloc.dart';

class SearchState extends Equatable {
  const SearchState._({
    this.status = SearchStatus.awaitingInput,
    this.request = SearchRequest.empty,
    this.uid = 0.0,
    this.result = const [],
  });

  const SearchState.awaitingInput() : this._();

  const SearchState.searching(SearchRequest request)
      : this._(status: SearchStatus.searching, request: request);

  const SearchState.displayingResults(double uid)
      : this._(status: SearchStatus.displayingResults, uid: uid);

  final SearchStatus status;
  final SearchRequest request;
  final double uid;
  final List<MovieResultDTO> result;

  @override
  List<Object> get props => [status, request, uid];
}
