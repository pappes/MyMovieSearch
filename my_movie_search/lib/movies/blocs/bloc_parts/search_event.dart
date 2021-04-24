part of '../search_bloc.dart';

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
  const SearchDataReceived();

  @override
  List<Object> get props => [];
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
