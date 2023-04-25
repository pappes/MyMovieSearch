import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/magnet_torrent_download_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/magnet_torrent_download_detail.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/webscrapers/magnet_torrent_download_detail.dart';
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
/// QueryTorrentDownloadDetail().readList(criteria, limit: 10)
/// ```
class QueryTorrentDownloadDetail
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeTorrentDownloadDetail {
  static const _baseURL = 'https://www.torrentdownload.info/';

  QueryTorrentDownloadDetail(SearchCriteriaDTO criteria) : super(criteria);

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() {
    return DataSourceType.torrentDownloadDetail.name;
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() {
    return streamHtmlOfflineData;
  }

  /// Convert map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is Map) {
      return TorrentDownloadDetailConverter.dtoFromCompleteJsonMap(map);
    }
    throw 'expected map got ${map.runtimeType} unable to interpret data $map';
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText() => criteria.toSearchId().toLowerCase();

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryTorrentDownloadDetail] $message',
        DataSourceType.torrentDownloadDetail,
      );

  /// API call to search returning the top matching results for [encodedCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final decodedCriteria = Uri.decodeComponent(searchCriteria);
    if (decodedCriteria.startsWith(_baseURL)) {
      return Uri.parse(decodedCriteria);
    }
    final url = '$_baseURL$searchCriteria';
    return Uri.parse(url);
  }
}
