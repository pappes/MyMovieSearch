// https://thetvdb.github.io/v4-api/#/Movies/getMovieBase

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/tvdb_movie_details.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/offline/tvdb_details.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tvdb_common.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tvdb_details.dart'
    as base_query;
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';

/// Implements [WebFetchBase] for movie data from The Movie Database (TVDB).
///
/// The TVDb API is a free web service to obtain movie information.
///
/// ```dart
/// QueryTVDBMovieDetails().readList(criteria);
/// ```
// ignore: missing_override_of_must_be_overridden
class QueryTVDBMovieDetails extends QueryTVDBCommon {
  QueryTVDBMovieDetails(super.criteria) {
    suffixURL = '/extended?short=true';
    source = DataSourceType.tvdbDetails;
    _setCriteria(criteria);
  }

  void _setCriteria(SearchCriteriaDTO criteria) {
    final contentType = criteria.criteriaContext?.type;
    if (contentType != null) {
      midURL = QueryTVDBCommon.typeToEndpoint(contentType);
    }
    movieContentType = contentType ?? movieContentType;
  }

  /// Check to see if IMDB ID needs to be converted to TVDB ID
  @override
  FutureOr<Uri> myConstructURIAsync(
    String searchCriteria, {
    int pageNumber = 1,
  }) async {
    await QueryTVDBCommon.init();
    var tvdbId = searchCriteria;
    if (searchCriteria.startsWith(imdbTitlePrefix)) {
      final header = await base_query.QueryTVDBDetails(
        SearchCriteriaDTO().fromString(searchCriteria),
      ).readList();
      if (header.isNotEmpty) {
        criteria.criteriaContext = header.first;
        criteria.criteriaTitle =
            header.first.sources[DataSourceType.tvdbDetails]!;
        tvdbId = criteria.criteriaTitle;
        _setCriteria(criteria);
      }
    }
    return myConstructURI(tvdbId, pageNumber: pageNumber);
  }

  MovieContentType movieContentType = MovieContentType.title;

  @override
  String myDataSourceName() => 'QueryTVDBMovieDetails';

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() => streamTvdbJsonOfflineData;

  /// Convert TVDB map to MovieResultDTO records.
  @override
  Future<Iterable<MovieResultDTO>> myConvertTreeToOutputType(dynamic map) =>
      // Use Future.sync to allow code to run synchronously and ensure
      // that exceptions are propagated as Future errors.
      Future.sync(() => convertSync(map));

  // Synchronous conversion of TVDB map to MovieResultDTO records.
  Iterable<MovieResultDTO> convertSync(dynamic map) {
    if (map is Map) {
      final dto = TvdbMovieDetailConverter(
        movieContentType,
      ).dtoFromCompleteJsonMap(map);
      return dto;
    }
    throw TreeConvertException(
      'expected map got ${map.runtimeType} unable to interpret data '
      '${map?.toString().characters.take(100)}',
    );
  }
}
