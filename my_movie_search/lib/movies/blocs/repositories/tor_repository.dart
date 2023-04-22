import 'package:my_movie_search/movies/blocs/repositories/repository_types/tor_multisearch_repository.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_glo_torrents.dart';
import 'package:my_movie_search/movies/web_data_providers/search/magnet_magnet_dl.dart';
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
    final textCriteria = criteria.clone();
    textCriteria.criteriaList = [];
    final providers = <WebFetchBase<MovieResultDTO, SearchCriteriaDTO>>[
      QueryTpbSearch(criteria),
      QueryMagnetDlSearch(criteria),
      QueryGloTorrentsSearch(criteria),
      QueryYtsSearch(criteria),
      QueryTorrentz2Search(criteria),
      QueryTpbSearch(textCriteria),
      QueryMagnetDlSearch(textCriteria),
      QueryGloTorrentsSearch(textCriteria),
      QueryYtsSearch(textCriteria),
      QueryTorrentz2Search(textCriteria),
    ];
    for (final provider in providers) {
      initProvider();
      provider
          .readList(limit: 10)
          .then((values) => addResults(searchUID, values))
          .whenComplete(finishProvider);
    }
  }
}
