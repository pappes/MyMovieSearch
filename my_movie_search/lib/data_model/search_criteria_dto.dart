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
