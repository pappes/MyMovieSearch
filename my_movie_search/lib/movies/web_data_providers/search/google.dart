import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/web_data/provider_controller.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/google.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/google.dart';

const GOOGLE_RESULTS_PER_PAGE = 10; // More than 10 results in an error!

/// Implements [SearchProvider] for searching the Open Movie Database.
/// The Google API is a free web service to obtain movie information.
class QueryGoogleMovies
    extends ProviderController<MovieResultDTO, SearchCriteriaDTO> {
  static final baseURL =
      'https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key=';

  /// Describe where the data is comming from.
  @override
  String dataSourceName() {
    return describeEnum(DataSourceType.google);
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn offlineData() {
    return streamGoogleMoviesJsonOfflineData;
  }

  /// Convert google map to MovieResultDTO records.
  @override
  List<MovieResultDTO> transformMap(Map map) {
    return GoogleMovieSearchConverter.dtoFromCompleteJsonMap(map);
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String toText(dynamic contents) {
    return contents!.criteriaTitle;
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO constructError(String message) {
    var error = MovieResultDTO().error();
    error.title = '[${this.runtimeType}] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.google;
    return error;
  }

  /// API call to Google returning the top 10 matching results for [searchText].
  @override
  Uri constructURI(String searchCriteria, {int pageNumber = 1}) {
    final googleKey =
        env['GOOGLE_KEY']; // From the file assets/.env (not source controlled)
    final startRecord = (pageNumber - 1) * GOOGLE_RESULTS_PER_PAGE;
    final url = '$baseURL$googleKey'
        '&q=$searchCriteria&start=$startRecord&'
        'num=$GOOGLE_RESULTS_PER_PAGE';
    return Uri.parse(url);
  }
}
