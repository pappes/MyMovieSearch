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

/// Search for download data from multiple torrent sources.
class TorRepository extends TorMultiSearchRepository {
  /// Initiates a search for the provided [criteria].
  ///
  /// [searchUID] is a unique correlation ID identifying this search request
  @override
  void initSearch(int searchUID, SearchCriteriaDTO criteria) {
    for (final provider in _getProviders(criteria)) {
      initProvider();
      provider
          .readList(limit: 10)
          .then((values) => addResults(searchUID, values))
          .whenComplete(finishProvider);
    }
  }

  /// Determine best provider(s) for the supplied criteria.
  List<WebFetchBase<MovieResultDTO, SearchCriteriaDTO>> _getProviders(
    SearchCriteriaDTO criteria,
  ) {
    if (criteria.criteriaList.isNotEmpty) {
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
