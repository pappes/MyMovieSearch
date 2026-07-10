import 'package:meta/meta.dart';
import 'package:my_movie_search/movies/data/search_criteria_mappers.dart';
import 'package:my_movie_search/movies/domain/models/search_criteria_enums.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';

/// Extension methods for creating and editing a `SearchCriteriaDTO`.
extension TransformationSearchCriteriaDTOHelpers on SearchCriteriaDTO {
  /// Initialize a [SearchCriteriaDTO].
  void init(
    SearchCriteriaType source, {
    String title = '',
    MovieResultDTO? context,
    List<MovieResultDTO> list = const [],
  }) {
    criteriaTitle = title;
    criteriaType = source;
    criteriaContext = context;
    criteriaList = list;
  }

  /// Create a duplicate of a `SearchCriteriaDTO`.
  @factory
  // Linter does not understand that fromJson is a factory method.
  // ignore: invalid_factory_method_impl
  SearchCriteriaDTO clone({bool condensed = false, bool inflate = false}) =>
      toMap(condensed: condensed).toSearchCriteriaDTO(inflate: inflate);
}
