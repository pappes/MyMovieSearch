import 'dart:io';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/yts_detail_api.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_title.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

// const jsonKeywordKey = 'keyword';
// const jsonPageKey = 'page';
// const jsonCategoryKey = 'category';
// const jsonMagnetKey = 'magnet';
// const jsonNameKey = 'name';
// const jsonImageKey = 'image';
// const jsonYearKey = 'year';
// const jsonDescriptionKey = 'description';
// const jsonSeedersKey = 'seeders';
// const jsonLeechersKey = 'leechers';


const apiBaseUrl = 'https://movies-api.accel.li/api/v2/';
const apiMovieUrl = 'movie_details.json?imdb_id=';

/// Implements [WebFetchBase] for retrieving full list of keywords
/// for a movie from IMDB.
///
/// ```dart
/// QueryYtsDetailApi().readList(criteria);
/// ```
class QueryYtsDetailApi
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  QueryYtsDetailApi(super.criteria);

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => 'yts_detail_api';

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamImdbHtmlOfflineData;

  /// converts SearchCriteriaDTO to a string representation.
  @override
  String myFormatInputAsText() {
    final text = criteria.criteriaContext?.uniqueId;
    if (text == null || !text.startsWith(imdbTitlePrefix)) {
      return ''; // only allow searches for imdb IDs
    }
    return text;
  }

  /// API call to YTS API returning all torrents for [searchCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {

    // remove imdbid prefix tt
    final cleanCriteria = searchCriteria.replaceFirst(imdbTitlePrefix, '');
    final url = '$apiBaseUrl$apiMovieUrl$cleanCriteria';
    return Uri.parse(url);
  }

  /// Convert YTS json to MovieResultDTO records.
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(
    dynamic map,
  ) async {
    if (map is Map) {
      return YtsDetailApiConverter.dtoFromCompleteJsonMap(map);
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  // Set YTS specific headers
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
      ..set('accept-encoding', 'text/plain');
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
    '[QueryYtsDetailApi] $message',
    DataSourceType.ytsDetailApi,
  );
}
