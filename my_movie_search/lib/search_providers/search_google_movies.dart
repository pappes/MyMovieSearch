import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:my_movie_search/search_providers/search_provider.dart';
import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/search_providers/temp_search_google_movies_data.dart';
import 'package:my_movie_search/search_providers/search_google_movie_converter.dart';

const GOOGLE_RESULTS_PER_PAGE = 10; // More than 10 results in an error!

/// Implements [SearchProvider] for searching the Open Movie Database.
/// The Google API is a free web service to obtain movie information.
class QueryGoogleMovies extends SearchProvider<MovieResultDTO> {
  static final baseURL =
      "https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key=";

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn offlineData() {
    return streamGoogleMoviesJsonOfflineData;
  }

  /// Convert from [json] [Stream] to
  /// a stream containing a [List] of [MovieResultDTO].
  @override
  Stream<List<MovieResultDTO>> transformStream(Stream<String> str) {
    return str.transform(json.decoder).map(
        (event) => GoogleMovieSearchConverter.dtoFromCompleteJsonMap(event));
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
