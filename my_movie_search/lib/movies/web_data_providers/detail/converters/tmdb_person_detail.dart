// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tmdb_common.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

const outerElementFailureIndicator = 'success';
const outerElementFailureReason = 'status_message';
const innerElementIdentity = 'id';
const innerElementImdbId = 'imdb_id';
const innerElementImage = 'profile_path';
const innerElementYear = 'birthday';
const innerElementAdult = 'adult';
const innerElementCommonTitle = 'name';
const innerElementOverview = 'biography';
const innerElementVoteAverage = 'popularity';

class TmdbPersonDetailConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    // deserialise outer json from map then iterate inner json
    final searchResults = <MovieResultDTO>[];

    final failureIndicator = map[outerElementFailureIndicator];
    if (null == failureIndicator) {
      searchResults.add(dtoFromMap(map));
    } else {
      final error = MovieResultDTO();
      error.title = map[outerElementFailureReason]?.toString() ??
          'No failure reason provided in results $map';
      searchResults.add(error);
    }
    return searchResults;
  }

  static MovieResultDTO dtoFromMap(Map map) {
    final year = DateTime.tryParse(
      map[innerElementYear]?.toString() ?? '',
    )?.year.toString();

    final person = MovieResultDTO().init(
      bestSource: DataSourceType.tmdbPerson,
      uniqueId: map[innerElementIdentity]?.toString(),
      title: map[innerElementCommonTitle]?.toString(),
      description: map[innerElementOverview]?.toString(),
      type: MovieContentType.person.toString(),
      year: year,
      userRatingCount: '1',
      userRating: DoubleHelper.fromText(
        map[innerElementVoteAverage],
      )?.toString(),
    );

    final poster = map[innerElementImage];
    if (null != poster) {
      person.imageUrl = '$tmdbPosterPathPrefix$poster';
    }

    person.uniqueId = map[innerElementImdbId]?.toString() ?? person.uniqueId;
    // Set the dto uniqueId to the IMDBID and the source ID to the TMDBID
    // no longer need to have alternateId field
    return person;
  }
}
