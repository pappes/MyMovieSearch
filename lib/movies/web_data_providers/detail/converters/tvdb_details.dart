import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/tvdb_common.dart';

const keyResult = 'status';
const keyResultSucessful = 'success';
const keyData = 'data';
const keyMovie = 'movie';
const keySeries = 'series';
const keyEpisode = 'episode';
const keyPerson = 'people';

class TvdbDetailConverter extends TvdbCommonConverter {
  TvdbDetailConverter(String imdbId) : super() {
    this.imdbId = imdbId;
  }

  MovieContentType getContentType(String? resultType) => switch (resultType) {
    keyEpisode => MovieContentType.episode,
    keySeries => MovieContentType.series,
    keyPerson => MovieContentType.person,
    _ => MovieContentType.title,
  };

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
              if (entry.key == keyMovie ||
                  entry.key == keySeries ||
                  entry.key == keyEpisode ||
                  entry.key == keyPerson) {
                resultData.addAll(entry.value as Map<dynamic, dynamic>);
                return getContentType(entry.key.toString());
                ;
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
