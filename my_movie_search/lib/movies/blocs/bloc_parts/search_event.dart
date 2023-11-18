part of '../search_bloc.dart';

/// Notify that a search reult has been received.
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchRequested extends SearchEvent {
  const SearchRequested(this.criteria);

  final SearchCriteriaDTO criteria;

  @override
  List<Object> get props => [criteria];
}

class SearchDataReceived extends SearchEvent {
  const SearchDataReceived(this.results);

  final List<MovieResultDTO> results;
  @override
  List<Object> get props => [results];
}

class SearchCompleted extends SearchEvent {
  const SearchCompleted();

  @override
  List<Object> get props => [];
}

class SearchCancelled extends SearchEvent {
  const SearchCancelled();

  @override
  List<Object> get props => [];
}
