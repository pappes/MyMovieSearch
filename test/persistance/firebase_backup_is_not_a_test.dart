import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_location.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';
import 'package:my_movie_search/persistence/meilisearch.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

void main() async {
  group('firebase backup', () {
    test(
      timeout: const Timeout(Duration(minutes: 60)),
      skip: true,
      'backupFirebaseData',
      () async {
        await backupFirebaseData();
      },
    );
    test(
      timeout: const Timeout(Duration(minutes: 60)),
      skip: false,
      'getDataForSearchEngine',
      () async {
        await getDataForSearchEngine();
      },
    );
  });
}

Future<void> getDataForSearchEngine() async {
  final filename = '/tmp/movieDetails${DateTime.now().toIso8601String()}.txt';
  await writeDataFile(filename, getMovieDetails);
}

Future<void> backupFirebaseData() async {
  logger.w(
    'Constant lastFirebaseBackupDate needs to be updated in '
    'lib/movies/models/movie_location.dart',
  );
  final filename = '/tmp/firebaseBackup${DateTime.now().toIso8601String()}.txt';
  await writeDataFile(
    filename,
    () async => jsonEncode(await getFirebaseData()),
  );
}

typedef JsonCallback = Future<String> Function();

Future<void> writeDataFile(String filename, JsonCallback jsonGenerator) async {
  WidgetsFlutterBinding.ensureInitialized();

  logger.w(
    'backup started at timestamp ${DateTime.now().millisecondsSinceEpoch}',
  );

  final data = await jsonGenerator();
  await File(filename).writeAsString(data, flush: true);

  logger.w(
    'Backup written to $filename '
    'file size: ${data.length}',
  );
}

Future<Map<String, dynamic>> getFirebaseData() async {
  WidgetsFlutterBinding.ensureInitialized();
  final fb = MovieLocation();
  final data = await fb.getBackupData();

  logger.w('Database statistics: ${fb.statistics()}');
  return data;
}

Future<String> getMovieDetails() async {
  final movieDetails = <MovieResultDTO>[];
  final futures = <Future<dynamic>>[];
  final movies = await getFirebaseData();
  int recordNumber = 1;

  final searchEngine = MeiliSearch(indexName: 'dvds');

  // Loop through each movie in the Firebase data.
  for (final uniqueId in movies.keys) {
    logger.w(
      'Fetching record ${recordNumber++} '
      'of ${movies.keys.length} uniqueId:$uniqueId',
    );
    // Delay execution for 1 second to avoid rate limiting issues.
    await Future<void>.delayed(const Duration(seconds: 1));

    // Fetch movie details from IMDB.
    final criteria = SearchCriteriaDTO().init(
      SearchCriteriaType.movieTitle,
      title: uniqueId,
    );
    final imdbData = QueryIMDBTitleDetails(criteria).readList();
    for (final movie in await imdbData) {
      if (movie.uniqueId == uniqueId) {
        await searchEngine.addDocument(movie);
      }

      // Add the fetched details to the list of movie details.
      movieDetails.add(movie);
    }
  }

  // Wait for all asynchronous operations to complete before returning.
  await Future.wait(futures);
  return movieDetails.toJson();
}
