import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/magnet_torrent_download_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/magnet_torrent_download_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/webscrapers/magnet_torrent_download_search.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const jsonKeywordKey = 'keyword';
const jsonPageKey = 'page';
const jsonCategoryKey = 'category';
const jsonDetailLink = 'url';
const jsonNameKey = 'name';
const jsonDescriptionKey = 'description';
const jsonSeedersKey = 'seeders';
const jsonLeechersKey = 'leechers';

/// Implements [WebFetchBase] for the Torrentz2 search html web scraper.
///
/// ```dart
/// QueryTorrentDownloadSearch().readList(criteria, limit: 10)
/// ```
class QueryTorrentDownloadSearch
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeTorrentDownloadSearch {
  QueryTorrentDownloadSearch(super.criteria);

  // Note url /search/ will order by peers but /searchr/ will order by relevance
  static const _baseURL = 'https://www.torrentdownload.info/search?q=';
  static const _pageURL = '&p=';

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.torrentDownloadSearch.name;

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamHtmlOfflineData;

  /// Convert map to MovieResultDTO records.
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(
    dynamic map,
  ) async {
    if (map is Map) {
      return TorrentDownloadSearchConverter.dtoFromCompleteJsonMap(map);
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText() => criteria.toPrintableIdOrText().toLowerCase();

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryTorrentDownloadSearch] $message',
        DataSourceType.torrentDownloadSearch,
      );

  /// API call to search
  /// returning the top matching results for [encodedCriteria].
  @override
  Uri myConstructURI(String encodedCriteria, {int pageNumber = 1}) {
    final convertedCriteria = encodedCriteria.replaceAll('.', '+');

    final url = '$_baseURL$convertedCriteria$_pageURL$pageNumber';
    return Uri.parse(url);
  }
}
