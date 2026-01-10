import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:quiver/collection.dart';

const errorsCollection = 'Recent Errors';

class Stats {
  Stats(this.source);
  int qtyRequests = 0;
  int qtyResponses = 0;
  int qtyCachedResponses = 0;
  int qtyEmptyResponses = 0;
  int qtyErrors = 0;
  String lastError = '';
  final recentErrors = LruMap<String, MovieResultDTO>(maximumSize: 10);
  String source;

  void addError(String error) {
    final dto = _formatError(error);
    recentErrors[dto.uniqueId] = dto;
    lastError = error;
    qtyErrors++;
  }

  MovieResultDTO formatStatistic() => MovieResultDTO()
    ..error(source)
    ..creditsOrder = qtyErrors
    ..userRating = qtyCachedResponses.toDouble()
    ..userRatingCount = qtyRequests
    ..description =
        'requests:$qtyRequests  -  '
        'responses:$qtyResponses  -  '
        'cachedResponses:$qtyCachedResponses  -  '
        'emptyResponses:$qtyEmptyResponses  -  '
        'errors:$qtyErrors\n'
    ..alternateTitle = '${lastError.characters.take(1000)}'
    ..related = {errorsCollection: recentErrors};

  MovieResultDTO _formatError(String error) => MovieResultDTO()
    ..error()
    ..title = source
    ..alternateTitle = error;
}

/// Log statisitics for WebFetchBase.
class WebLog {
  WebLog(this.source) {
    if (!statistics.containsKey(source)) {
      statistics[source] = Stats(source);
    }
  }
  static final statistics = <String, Stats>{};

  String source;

  /// Record that a request has been made.
  void logRequest(dynamic criteria) {
    statistics[source]!.qtyRequests++;
  }

  void logResponse(dynamic criteria, dynamic dto, {bool cached = false}) {
    statistics[source]!.qtyResponses++;
    if (cached) {
      statistics[source]!.qtyCachedResponses++;
    }
  }

  void logEmptyResponse(dynamic criteria) {
    statistics[source]!.qtyResponses++;
  }

  /// Record that a response has been received.
  void logResponses<T>(
    dynamic criteria,
    Iterable<T> dtos, {
    bool cached = false,
  }) {
    for (final dto in dtos) {
      logResponse(criteria, dto, cached: cached);
    }
  }

  /// Record that a response has been received.
  Stream<T> logResponsesAsync<T>(
    dynamic criteria,
    Stream<T> dtos, {
    bool cached = false,
  }) async* {
    await for (final dto in dtos) {
      logResponse(criteria, dto, cached: cached);
      yield dto;
    }
  }

  /// Record that an error has occurred.
  void logError(dynamic criteria, String error) =>
      statistics[source]!.addError(error);

  /// Retrieve statistics for all sources.
  static Iterable<Stats> getStats() =>
      statistics.values;
}
