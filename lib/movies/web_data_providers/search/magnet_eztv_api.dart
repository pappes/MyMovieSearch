import 'dart:io';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/magnet_eztv_api.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/magnet_eztv_api.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

const jsonKeywordKey = 'keyword';
const jsonPageKey = 'page';
const jsonMagnetKey = 'magnet';
const jsonNameKey = 'name';
const jsonSeedersKey = 'seeders';

/// Implements [WebFetchBase] for the MagnetEztv search html web scraper.
///
/// ```dart
/// QueryMagnetEztvSearch().readList(criteria, limit: 10)
/// ```
class QueryMagnetEztvApiSearch
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  QueryMagnetEztvApiSearch(super.criteria);

  static const _baseURL = 'https://eztv.yt/api/get-torrents?limit=100&imdb_id=';

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => DataSourceType.eztvApi.name;

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
      return MagnetEztvApiSearchConverter.dtoFromCompleteJsonMap(map);
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  /// converts SearchCriteriaDTO to a string representation.
  ///
  /// only imdb_id is used.
  /// need to strip the tt prefix from the imdb_id.
  @override
  String myFormatInputAsText() =>
      criteria.toPrintableIdOrText().replaceAll(imdbTitlePrefix, '');

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
    '[QueryMagnetEztvApiSearch] $message',
    DataSourceType.eztvApi,
  );

  /// API call to search
  /// returning the top matching results for [encodedCriteria].
  @override
  Uri myConstructURI(String encodedCriteria, {int pageNumber = 1}) {
    final url = '$_baseURL$encodedCriteria';
    return Uri.parse(url);
  }

  // Set extv specific headers
  @override
  void myConstructHeaders(HttpHeaders headers) {
    super.myConstructHeaders(headers);
    // prevent invalid UTF encoding.
    headers
      ..set(
        'accept',
        'text/html,application/xhtml+xml,application/xml',
        // do not accept ;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7,
      )
      ..set('accept-encoding', 'text/plain')
      ..set('Cookie', 'layout=def_wlinks');
  }
}
