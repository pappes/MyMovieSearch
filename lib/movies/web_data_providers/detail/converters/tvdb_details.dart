import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

const keyResult = 'status';
const keyResultSucessful = 'success';
const keyData = 'data';
const keyMovie = 'movie';
const keySeries = 'series';
const keyEpisode = 'episode';
const keyPerson = 'people';

const resultEmpty = 'empty';

const outerElementFailureIndicator = 'message';
const elementIdentity = 'id';
const elementTitle = 'name';
const elementRuntime = 'runtime';
const elementSeriesRuntime = 'averageRuntime';
const elementYear = 'year';
const elementSeriesYear = 'firstAired';
const elementEpisodeYear = 'aired';
const elementEndYear = 'lastAired';
const elementImage = 'image';
const elementOverview = 'overview';
const tmdbBaseUrl = 'https://artworks.thetvdb.com';

class TvdbDetailConverter {
  TvdbDetailConverter(this.imdbId);

  String imdbId;
  String? resultType;
  Map<dynamic, dynamic> resultData = {};
  String? failureMessage;

  List<MovieResultDTO> dtoFromCompleteJsonMap(Map<dynamic, dynamic> map) {
    // deserialise outer json from map then iterate inner json
    final searchResults = <MovieResultDTO>[];

    parseResultTypeAndData(map);
    if (resultType == resultEmpty) {
      return searchResults;
    } else if (null == failureMessage) {
      searchResults.add(dtoFromMap());
    } else {
      searchResults.add(
        MovieResultDTO().error(
          '[TvdbDetailConverter] $failureMessage',
          DataSourceType.tvdbDetails,
        ),
      );
    }
    return searchResults;
  }

  void parseResultTypeAndData(Map<dynamic, dynamic> map) {
    // {"data": [ { movie: { ... } } ] }
    // {"data": [ { series: { ... } } ] }
    // {"data": [ { episode: { ... } } ] }
    // {"data": [ { person: { ... } } ] }
    // {"status": "success", "data": null }
    try {
      failureMessage = getFailureReasonFromMap(map);
      if (null != failureMessage) {
        return;
      }
      final returnedData = map[keyData];
      if (map[keyResult] == keyResultSucessful && returnedData == null) {
        // No data found
        resultType = resultEmpty;
        return;
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
                resultType = entry.key.toString();
                resultData = entry.value as Map<dynamic, dynamic>;
                return;
              }
            }
          }
        }
      }
    } catch (_) {}
    failureMessage = 'Unable to interpret results $map';
  }

  String? getFailureReasonFromMap(Map<dynamic, dynamic> map) {
    final failureIndicator = map[outerElementFailureIndicator];
    if (null != failureIndicator) {
      return failureIndicator?.toString() ??
          'Failure reason provided in results $map';
    }
    return null;
  }

  MovieResultDTO dtoFromMap() {
    final movie = MovieResultDTO()
      ..setSource(
        newSource: DataSourceType.tvdbDetails,
        newUniqueId: '${resultData[elementIdentity]}',
      )
      ..type = switch (resultType) {
        keyEpisode => MovieContentType.episode,
        keySeries => MovieContentType.series,
        keyPerson => MovieContentType.person,
        _ => MovieContentType.title,
      };

    final mins = IntHelper.fromText(
      resultData[elementRuntime] ?? resultData[elementSeriesRuntime],
    );
    final year =
        DateTime.tryParse('${resultData[elementYear]}')?.year ??
        DateTime.tryParse('${resultData[elementSeriesYear]}')?.year ??
        DateTime.tryParse('${resultData[elementEpisodeYear]}')?.year;
    var image = resultData[elementImage]?.toString();
    if (image != null && image.startsWith('/banners')) {
      image = '$tmdbBaseUrl$image';
    }

    movie
      ..uniqueId = imdbId
      ..title = resultData[elementTitle]?.toString() ?? movie.title
      ..year = year ?? movie.year
      ..runTime = _getDuration(mins) ?? movie.runTime
      ..description =
          resultData[elementOverview]?.toString() ?? movie.description
      ..imageUrl = image ?? movie.imageUrl
      ..getContentType()
      ..getLanguageType();

    final endYear =
        DateTime.tryParse('${resultData[elementEndYear]}')?.year ?? '';
    if (resultType == keySeries || resultType == keyEpisode) {
      movie.yearRange = '${movie.year}-$endYear';
    }

    return movie;
  }

  static Duration? _getDuration(int? mins) {
    if (null == mins) {
      return null;
    }
    return Duration(minutes: mins);
  }
}
