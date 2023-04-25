import 'package:my_movie_search/movies/blocs/repositories/repository_types/base_movie_repository.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/yts_detail.dart';

typedef SearchFunction = Future<List<MovieResultDTO>> Function(
  MovieResultDTO criteria,
);

class SearchFunctions {
  List<SearchFunction> supplementarySearch = [];
}

/// Search for movie data from multiple online search sources.
///
/// BlockRepository to consolidate data retrieval from multiple search
/// and detail providers using the WebFetch framework.
///
/// [Search] provides a stream of incomplete and complete results.
/// [Close] can be used to cancel a search.
class TorMultiSearchRepository extends BaseMovieRepository {
  /// Maintain a map of unique movie detail requests
  /// and request retrieval if the fetch is not already in progress.
  @override
  void getExtraDetails(int originalSearchUID, MovieResultDTO dto) {
    if ("null" != dto.uniqueId &&
        !dto.uniqueId.startsWith(movieDTOMessagePrefix)) {
      final functions = SearchFunctions();
      _getDetailSources(dto, functions);
      // Load supplementary results into list for display on screen
      for (final function in functions.supplementarySearch) {
        function(dto).then(
          (searchResults) => _addExtraDetails(originalSearchUID, searchResults),
        );
      }
    }
  }

  /// Call YTS details when YTS search has completed
  bool _readyForYtsDetails(MovieResultDTO dto) {
    if (dto.sources.containsKey(DataSourceType.ytsSearch) &&
        !dto.sources.containsKey(DataSourceType.ytsDetails)) {
      return true;
    }
    return false;
  }

  /// Maintain a map of unique movie detail requests
  /// and request retrieval if the fetch is not already in progress.
  void _getDetailSources(MovieResultDTO dto, SearchFunctions functions) {
    if (_readyForYtsDetails(dto)) {
      functions.supplementarySearch.add(_getYtsDetails);
    }
  }

  /// Fetch YTS details from the url.
  static Future<List<MovieResultDTO>> _getYtsDetails(MovieResultDTO dto) {
    final detailCriteria = SearchCriteriaDTO().fromString(dto.uniqueId);
    return QueryYtsDetails(detailCriteria).readList();
  }

  /// Add fetched torrent details into the stream and search for more details.
  ///
  /// YtsSearch returns a URL based on an IMDB ID
  /// which then requires another call to get YTS details
  void _addExtraDetails(int originalSearchUID, List<MovieResultDTO> values) {
    if (!searchInterrupted(originalSearchUID)) {
      for (final dto in values) {
        yieldResult(dto);
        getExtraDetails(originalSearchUID, dto);
      }
    }
  }
}