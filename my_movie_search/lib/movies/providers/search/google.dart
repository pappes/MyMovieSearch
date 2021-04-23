import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:my_movie_search/utilities/provider_controller.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/providers/search/offline/google.dart';
import 'package:my_movie_search/movies/providers/search/converters/google.dart';

const GOOGLE_RESULTS_PER_PAGE = 10; // More than 10 results in an error!

/// Implements [SearchProvider] for searching the Open Movie Database.
/// The Google API is a free web service to obtain movie information.
class QueryGoogleMovies extends ProviderController<MovieResultDTO> {
  static final baseURL =
      "https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key=";

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
    var x = GoogleMovieSearchConverter.dtoFromCompleteJsonMap(map);
    return x;
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  List<MovieResultDTO> constructError(String message) {
    var error = MovieResultDTO();
    error.title = "[${this.runtimeType}] $message";
    error.type = MovieContentType.custom;
    error.source = DataSourceType.google;
    error.uniqueId = "-${error.source}";
    return [error];
  }

  /// API call to Google returning the top 10 matching results for [searchText].
  @override
  Uri constructURI(String searchText, {int pageNumber = 1}) {
    final googleKey =
        env["GOOGLE_KEY"]; // From the file assets/.env (not source controlled)
    final startRecord = (pageNumber - 1) * GOOGLE_RESULTS_PER_PAGE;
    final url = "$baseURL$googleKey"
        "&q=$searchText&start=$startRecord&num=$GOOGLE_RESULTS_PER_PAGE";
    return Uri.parse(url);
  }
}
