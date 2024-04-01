import 'dart:async';

import 'package:my_movie_search/movies/blocs/repositories/repository_types/tor_multisearch_repository.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_glo_torrents.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_magnet_dl.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_solid_torrents.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_torrent_download_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_torrentz2.dart';
import 'package:my_movie_search/movies/web_data_providers/search/tpb_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/yts_search.dart';
import 'package:my_movie_search/utilities/web_data/src/web_fetch_base.dart';

typedef WebFetch = WebFetchBase<MovieResultDTO, SearchCriteriaDTO>;

/// Search for download data from multiple torrent sources.
class TorRepository extends TorMultiSearchRepository {
  /// Initiates a search for the provided [criteria].
  ///
  /// [searchUID] is a unique correlation ID identifying this search request
  @override
  Future<void> initSearch(int searchUID, SearchCriteriaDTO criteria) async {
    await _advancedDownloadCard(searchUID);

    for (final provider in _getProviders(criteria)) {
      unawaited(_search(searchUID, provider));
    }
  }

  Future<void> _search(int searchUID, WebFetch provider) async {
    initProvider(provider);

    final results = await provider.readList(limit: 10);
    return addResults(searchUID, results)
        .then((value) => finishProvider(provider));
  }

  /// Manufacture a navigation card
  /// to expand downloadSimple to downloadAdvanced
  Future<void> _advancedDownloadCard(int searchUID) async {
    if (criteria.criteriaType == SearchCriteriaType.downloadSimple) {
      return addResults(
        searchUID,
        [
          MovieResultDTO().init(
            uniqueId: criteria.criteriaTitle,
            title: 'More search providers...',
            type: MovieContentType.navigation.toString(),
          ),
        ],
      );
    }
  }

  /// Determine best provider(s) for the supplied criteria.
  List<WebFetch> _getProviders(SearchCriteriaDTO criteria) {
    if (criteria.criteriaType == SearchCriteriaType.downloadSimple) {
      // Yts searches based on IMDB ID
      return [QueryYtsSearch(criteria)];
    }
    return [
      // Other providers search based on movie title
      QueryTpbSearch(criteria),
      QueryMagnetDlSearch(criteria),
      QueryGloTorrentsSearch(criteria),
      QueryTorrentz2Search(criteria),
      QuerySolidTorrentsSearch(criteria),
      QueryTorrentDownloadSearch(criteria),
    ];
  }
}
