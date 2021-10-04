import 'package:flutter/foundation.dart' show describeEnum;
import 'package:flutter_dotenv/flutter_dotenv.dart' show env;

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'converters/omdb.dart';
import 'offline/omdb.dart';

/// Implements [WebFetchBase] for searching the Open Movie Database.
/// The OMDb API is a free web service to obtain movie information.
class QueryOMDBMovies extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static const _baseURL = 'https://www.omdbapi.com/?apikey=';

  /// Describe where the data is comming from.
  @override
  String myDataSourceName() {
    return describeEnum(DataSourceType.omdb);
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() {
    return streamOmdbJsonOfflineData;
  }

  /// Convert OMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> myTransformMapToOutput(Map map) =>
      OmdbMovieSearchConverter.dtoFromCompleteJsonMap(map);

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText(dynamic contents) {
    final criteria = contents as SearchCriteriaDTO;
    return criteria.criteriaTitle;
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) {
    final error = MovieResultDTO();
    error.title = '[QueryOMDBMovies] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.omdb;
    return error;
  }

  /// API call to OMDB returning the top 10 matching results for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final omdbKey =
        env["OMDB_KEY"]; // From the file assets/.env (not source controlled)
    return Uri.parse(
      '$_baseURL$omdbKey&s=$searchCriteria&page=$pageNumber',
    );
  }
}
