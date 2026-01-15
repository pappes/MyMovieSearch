import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

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
const elementSourceUrls = 'sourceUrls';
const tmdbBaseImageUrl = 'https://artworks.thetvdb.com';

const resultEmpty = 'empty';
const resultError = 'error';

abstract class TvdbCommonConverter {
  MovieContentType parseResultTypeAndData(
    Map<dynamic, dynamic> inputData,
    Map<dynamic, dynamic> outputData,
  );

  String? imdbId;
  String? failureMessage;
  final dataSource = DataSourceType.tvdbDetails;
  late String dataSourceName = 'TvdbDetailConverter';

  List<MovieResultDTO> dtoFromCompleteJsonMap(Map<dynamic, dynamic> map) {
    // deserialise outer json from map then iterate inner json
    final searchResults = <MovieResultDTO>[];
    final resultData = <dynamic, dynamic>{};
    dataSourceName = dataSource.name; //datasource

    final resultType = parseResultTypeAndData(map, resultData);
    if (resultType == MovieContentType.none) {
      return searchResults;
    } else if (failureMessage == null) {
      searchResults.add(dtoFromMap(resultType, resultData, imdbId: imdbId));
    } else {
      searchResults.add(
        MovieResultDTO().error('[$dataSourceName] $failureMessage', dataSource),
      );
    }
    return searchResults;
  }

  MovieResultDTO dtoFromMap(
    MovieContentType resultType,
    Map<dynamic, dynamic> resultData, {
    String? imdbId,
  }) {
    final movie = MovieResultDTO()
      ..setSource(
        newSource: DataSourceType.tvdbDetails,
        newUniqueId: '${resultData[elementIdentity]}',
      )
      ..type = resultType;

    final mins = IntHelper.fromText(
      resultData[elementRuntime] ?? resultData[elementSeriesRuntime],
    );
    final year =
        DateTime.tryParse('${resultData[elementYear]}')?.year ??
        DateTime.tryParse('${resultData[elementSeriesYear]}')?.year ??
        DateTime.tryParse('${resultData[elementEpisodeYear]}')?.year;
    var image = resultData[elementImage]?.toString();
    if (image != null && image.startsWith('/banners')) {
      image = '$tmdbBaseImageUrl$image';
    }

    movie
      ..uniqueId = imdbId ?? getImdbId()
      ..title = resultData[elementTitle]?.toString() ?? movie.title
      ..year = year ?? movie.year
      ..runTime = _getDuration(mins) ?? movie.runTime
      ..description =
          resultData[elementOverview]?.toString() ?? movie.description
      ..imageUrl = image ?? movie.imageUrl
      ..links.addAll(dynamicToStringMap(resultData[elementSourceUrls]))
      ..getContentType()
      ..getLanguageType();

    if (resultType == MovieContentType.series ||
        resultType == MovieContentType.episode) {
      if (movie.year > 0) {
        final endYear =
            DateTime.tryParse('${resultData[elementEndYear]}')?.year ?? '';
        movie.yearRange = '${movie.year}-$endYear';
      }
    }

    return movie;
  }

  String? getFailureReasonFromMap(Map<dynamic, dynamic> map) {
    final failureIndicator = map[outerElementFailureIndicator];
    if (null != failureIndicator) {
      return failureIndicator?.toString() ??
          'Failure reason provided in results $map';
    }
    return null;
  }

  static Duration? _getDuration(int? mins) {
    if (null == mins) {
      return null;
    }
    return Duration(minutes: mins);
  }

  String getImdbId() => '';
}
