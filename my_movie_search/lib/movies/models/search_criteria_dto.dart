import 'package:equatable/equatable.dart';

class SearchRequest extends Equatable {
  const SearchRequest(this.title);

  final String title;

  @override
  List<Object> get props => [title];

  static const empty = SearchRequest('-');
}

enum SearchStatus { awaitingInput, searching, cacheDirty, displayingResults }

enum SearchCriteriaSource {
  none,
  google,
  imdb,
  tpb,
  lime,
  custom,
}

class SearchCriteriaDTO {
  String criteriaTitle = "";
  SearchCriteriaSource criteriaSource = SearchCriteriaSource.none;
  String criteriaUrl = "";
}
