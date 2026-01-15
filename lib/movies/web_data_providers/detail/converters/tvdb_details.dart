import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/tvdb_common.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tvdb_common.dart';

const keyResult = 'status';
const keyResultSucessful = 'success';
const keyData = 'data';

class TvdbDetailConverter extends TvdbCommonConverter {
  TvdbDetailConverter(String imdbId) : super() {
    this.imdbId = imdbId;
  }

  @override
  MovieContentType parseResultTypeAndData(
    Map<dynamic, dynamic> inputData,
    Map<dynamic, dynamic> resultData,
  ) {
    // {"data": [ { movie: { ... } } ] }
    // {"data": [ { series: { ... } } ] }
    // {"data": [ { episode: { ... } } ] }
    // {"data": [ { person: { ... } } ] }
    // {"status": "success", "data": null }
    dataSourceName = 'TvdbMovieConverter';
    try {
      failureMessage = getFailureReasonFromMap(inputData);
      if (null != failureMessage) {
        return MovieContentType.error;
      }
      final returnedData = inputData[keyData];
      if (inputData[keyResult] == keyResultSucessful && returnedData == null) {
        // No data found
        return MovieContentType.none;
      }
      if (returnedData is List) {
        for (final row in returnedData) {
          if (row is Map) {
            for (final entry in row.entries) {
              // Dont care about seasons for a tv series.
              if (tvdbTypeMapping.keys.contains(entry.key)) {
                resultData.addAll(entry.value as Map<dynamic, dynamic>);
                final type = QueryTVDBCommon.typeToMovieContentType(
                  entry.key.toString(),
                );
                return type;
              }
            }
          }
        }
      }
    } catch (_) {}
    failureMessage = 'Unable to interpret results $inputData';
    return MovieContentType.error;
  }
}
