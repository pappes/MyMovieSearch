import 'dart:async';

import 'package:my_movie_search/movies/blocs/repositories/repository_types/base_movie_repository.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/magnet_torrent_download_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/yts_detail.dart';

/// Search for movie download data from multiple download sources.
///
/// BlockRepository to consolidate data retrieval from multiple download
/// providers using the WebFetch framework.
class TorMultiSearchRepository extends BaseMovieRepository {
  /// Maintain a map of unique movie detail requests
  /// and request retrieval if the fetch is not already in progress.
  @override
  Future<int> getExtraDetails(int originalSearchUID, MovieResultDTO dto) async {
    if (!dto.isAControlObject()) {
      return _callSearchFunction(originalSearchUID, dto);
    }
    return 0;
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
  Future<int> _callSearchFunction(
    int originalSearchUID,
    MovieResultDTO dto,
  ) async {
    final detailCriteria = SearchCriteriaDTO().fromString(dto.uniqueId);
    if (_readyForYtsDetails(dto)) {
      // Fetch YTS details from the url.
      const constructor = QueryYtsDetails.new;
      await _search(originalSearchUID, detailCriteria, constructor);
    }
    if (_readyForTDDetails(dto)) {
      // Fetch TorrentDownload details from the url.
      const constructor = QueryTorrentDownloadDetail.new;
      await _search(originalSearchUID, detailCriteria, constructor);
    }

    return 0;
  }

  Future<void> _search(
    int originalSearchUID,
    SearchCriteriaDTO criteria,
    WebFetchDTOFn searchClass,
  ) async {
    final provider = searchClass(criteria);
    initProvider(provider);
    final results = await provider.readList();
    return _addExtraDetails(
      originalSearchUID,
      results,
    ).then((_) => finishProvider(provider));
  }

  /// Add fetched torrent details into the stream and search for more details.
  ///
  /// YtsSearch returns a URL based on an IMDB ID
  /// which then requires another call to get YTS details
  Future<void> _addExtraDetails(
    int originalSearchUID,
    List<MovieResultDTO> values,
  ) async {
    if (!searchInterrupted(originalSearchUID)) {
      for (final dto in values) {
        if (!dto.isError()) {
          yieldResult(dto);
          unawaited(getExtraDetails(originalSearchUID, dto));
        }
      }
    }
  }
}
