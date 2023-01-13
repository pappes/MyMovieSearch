import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/omdb.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/omdb.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for searching the Open Movie Database.
///
/// The OMDb API is a free web service to obtain movie information.
///
/// ```dart
/// QueryOMDBMovies().readList(criteria, limit: 10)
/// ```
class QueryOMDBMovies extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static const _baseURL = 'https://www.omdbapi.com/?apikey=';

  /// Describe where the data is coming from.
  @override
  String myDataSourceName() {
    return DataSourceType.omdb.name;
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() {
    return streamOmdbJsonOfflineData;
  }

  /// Convert OMDB map to MovieResultDTO records.
  @override
  Future<List<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) async {
    if (map is Map) return OmdbMovieSearchConverter.dtoFromCompleteJsonMap(map);
    throw 'expected map got ${map.runtimeType} unable to interpret data $map';
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText(dynamic contents) {
    final criteria = contents as SearchCriteriaDTO;
    return criteria.toPrintableString();
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) => MovieResultDTO().error(
        '[QueryOMDBMovies] $message',
        DataSourceType.omdb,
      );

  /// API call to OMDB returning the top 10 matching results for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final omdbKey = dotenv
        .env["OMDB_KEY"]; // From the file assets/.env (not source controlled)
    return Uri.parse(
      '$_baseURL$omdbKey&s=$searchCriteria&page=$pageNumber',
    );
  }
}
