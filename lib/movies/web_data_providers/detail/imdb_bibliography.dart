import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/imdb_bibliography.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/imdb_title.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/webscrapers/imdb_bibliography.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for retrieving bibliography
/// and crew information from IMDB.
///
/// ```dart
/// QueryIMDBBibliographyDetails().readList(criteria);
/// ```
class QueryIMDBBibliographyDetails
    extends WebFetchThreadedCache<MovieResultDTO, SearchCriteriaDTO>
    with ScrapeIMDBBibliographyDetails {
  QueryIMDBBibliographyDetails(super.criteria);

  static const _baseURL = 'https://www.imdb.com/name/';
  static const _baseURLsuffix = '/fullcredits/';

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() => 'imdb_bibliography';

  @override
  @factory
  WebFetchThreadedCache<MovieResultDTO, SearchCriteriaDTO> myClone(
    SearchCriteriaDTO criteria,
  ) =>
      QueryIMDBBibliographyDetails(criteria);

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamImdbHtmlOfflineData;

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText() {
    final text = criteria.toPrintableString();
    if (text.startsWith(imdbPersonPrefix)) {
      return text;
    }
    return ''; // do not allow searches for non-imdb IDs
  }

  /// API call to IMDB search returning the top matching results
  /// for [searchCriteria].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final url = '$_baseURL$searchCriteria$_baseURLsuffix';
    return Uri.parse(url);
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(
    dynamic map,
  ) async {
    if (map is Map) {
      return ImdbBibliographyConverter.dtoFromCompleteJsonMap(map);
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data $map',
    );
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryIMDBBibliographyDetails] $message',
        DataSourceType.imdb,
      );
}
