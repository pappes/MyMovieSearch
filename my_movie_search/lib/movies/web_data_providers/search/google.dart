import 'package:flutter/foundation.dart' show describeEnum;
import 'package:flutter_dotenv/flutter_dotenv.dart' show env;

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'converters/google.dart';
import 'offline/google.dart';

const _googleResultsPerPage = 10; // More than 10 results in an error!

/// Implements [WebFetchBase] for searching the Open Movie Database.
/// The Google API is a free web service to obtain movie information.
class QueryGoogleMovies
    extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static const _baseURL =
      'https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key=';

  /// Describe where the data is comming from.
  @override
  String myDataSourceName() {
    return describeEnum(DataSourceType.google);
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() {
    return streamGoogleMoviesJsonOfflineData;
  }

  /// Convert google map to MovieResultDTO records.
  @override
  List<MovieResultDTO> myTransformMapToOutput(Map map) {
    return GoogleMovieSearchConverter.dtoFromCompleteJsonMap(map);
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText(dynamic contents) {
    final criteria = contents as SearchCriteriaDTO;
    return criteria.criteriaTitle;
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) {
    final error = MovieResultDTO().error();
    error.title = '[QueryGoogleMovies] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.google;
    return error;
  }

  /// API call to Google returning the top 10 matching results for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final googleKey =
        env['GOOGLE_KEY']; // From the file assets/.env (not source controlled)
    final startRecord = (pageNumber - 1) * _googleResultsPerPage;
    final url = '$_baseURL$googleKey'
        '&q=$searchCriteria&start=$startRecord&'
        'num=$_googleResultsPerPage';
    return Uri.parse(url);
  }
}
