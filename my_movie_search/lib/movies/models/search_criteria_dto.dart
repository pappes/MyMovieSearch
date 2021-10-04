import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/material.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';

import 'movie_result_dto.dart';

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
  String searchId = '';
  String criteriaTitle = '';
  SearchCriteriaSource criteriaSource = SearchCriteriaSource.none;
  List<MovieResultDTO> criteriaList = [];
}

class RestorableSearchCriteria extends RestorableValue<SearchCriteriaDTO> {
  @override
  SearchCriteriaDTO createDefaultValue() => SearchCriteriaDTO();

  @override
  void didUpdateValue(SearchCriteriaDTO? oldValue) {
    if (oldValue == null ||
        oldValue.searchId != value.searchId ||
        oldValue.criteriaTitle != value.criteriaTitle ||
        oldValue.criteriaSource != value.criteriaSource ||
        oldValue.criteriaList.toPrintableString() !=
            value.criteriaList.toPrintableString()) notifyListeners();
  }

  @override
  SearchCriteriaDTO fromPrimitives(Object? data) {
    if (data != null) {
      return getDTO(data as Map<String, String>);
    }
    return SearchCriteriaDTO();
  }

  SearchCriteriaDTO getDTO(Map<String, String> map) {
    final retVal = SearchCriteriaDTO();
    retVal.searchId = map['searchId'] ?? retVal.searchId;
    retVal.criteriaTitle = map['criteriaTitle'] ?? retVal.criteriaTitle;
    retVal.criteriaSource = getEnumValue<SearchCriteriaSource>(
          map['criteriaSource'],
          SearchCriteriaSource.values,
        ) ??
        retVal.criteriaSource;
//    retVal.criteriaList = map['criteriaList'] ?? retVal.criteriaList;
    return retVal;
  }

  @override
  Object toPrimitives() {
    final map = <String, String>{
      'searchId': value.searchId,
      'criteriaTitle': value.criteriaTitle,
      'criteriaSource': value.criteriaSource.toString(),
      'criteriaList': value.criteriaList.toJson(),
    };
    return map.toString();
  }
}
