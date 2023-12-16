import 'package:my_movie_search/movies/blocs/repositories/repository_types/base_movie_repository.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/magnet_torrent_download_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/yts_detail.dart';

typedef SearchFunction = Future<List<MovieResultDTO>> Function(
  MovieResultDTO criteria,
);

class SearchFunctions {
  List<SearchFunction> supplementarySearch = [];
}

/// Search for movie download data from multiple download sources.
///
/// BlockRepository to consolidate data retrieval from multiple download
/// providers using the WebFetch framework.
class TorMultiSearchRepository extends BaseMovieRepository {
  /// Maintain a map of unique movie detail requests
  /// and request retrieval if the fetch is not already in progress.
  @override
  int getExtraDetails(int originalSearchUID, MovieResultDTO dto) {
    int searchesRequested = 0;
    if ("null" != dto.uniqueId &&
        !dto.uniqueId.startsWith(movieDTOMessagePrefix)) {
      final functions = SearchFunctions();
      _getDetailSources(dto, functions);
      // Load supplementary results into list for display on screen
      for (final function in functions.supplementarySearch) {
        searchesRequested = searchesRequested + 1;
        function(dto).then(
          (searchResults) => _addExtraDetails(originalSearchUID, searchResults),
        );
      }
    }
    return searchesRequested;
  }

  /// Call YTS details when YTS search has completed
  bool _readyForYtsDetails(MovieResultDTO dto) {
    if (dto.sources.containsKey(DataSourceType.ytsSearch) &&
        !dto.sources.containsKey(DataSourceType.ytsDetails)) {
      return true;
    }
    return false;
  }

  /// Call TorrentDownload details when TorrentDownload search has completed
  bool _readyForTDDetails(MovieResultDTO dto) {
    if (dto.sources.containsKey(DataSourceType.torrentDownloadSearch) &&
        !dto.sources.containsKey(DataSourceType.torrentDownloadDetail)) {
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
    if (_readyForTDDetails(dto)) {
      functions.supplementarySearch.add(_getTDDetails);
    }
  }

  /// Fetch YTS details from the url.
  static Future<List<MovieResultDTO>> _getYtsDetails(MovieResultDTO dto) {
    final detailCriteria = SearchCriteriaDTO().fromString(dto.uniqueId);
    return QueryYtsDetails(detailCriteria).readList();
  }

  /// Fetch TorrentDownload details from the url.
  static Future<List<MovieResultDTO>> _getTDDetails(MovieResultDTO dto) {
    final detailCriteria = SearchCriteriaDTO().fromString(dto.uniqueId);
    return QueryTorrentDownloadDetail(detailCriteria).readList();
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
      finishProvider();
    }
  }
}
