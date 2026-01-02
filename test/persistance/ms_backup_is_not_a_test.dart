import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_location.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';
import 'package:my_movie_search/persistence/meilisearch.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

void main() {
  group('meilisearch backup', () {
    // Backup data stored in meilisearch to /tmp/meiliseachBackup<date>.txt
    //
    // getDataFromSearchEngine gets a list of DVDs from firebase
    // then retrieves the details from meilisearch,
    // json encodes it and writes it to a file.
    // Any local caches are cleared and data reloaded from source to ensure
    // that the data is up to date.
    test(
      timeout: const Timeout(Duration(minutes: 60)),
      skip: true,
      'getDataFromSearchEngine',
      () async {
        await getDataFromSearchEngine();
      },
    );
    test(
      // Backup firebase data + imdb data to /tmp/movieDetails<date>.txt
      //
      // getDataForSearchEngine gets data from firebase,
      // pulls down each record from imbd
      // adds it to ms
      // json encodes it and writes it to a file.
      // Any local caches are cleared and data reloaded from source to ensure
      // that the data is up to date.
      timeout: const Timeout(Duration(minutes: 60)),
      skip: true,
      'getDataForSearchEngine',
      () async {
        await getDataForSearchEngine();
      },
    );
  });
}

Future<void> getDataForSearchEngine() async {
  final filename = '/tmp/movieDetails${DateTime.now().toIso8601String()}';
  await writeJsonFile(filename, getMovieDetails);
}

Future<void> getDataFromSearchEngine() async {
  final filename = '/tmp/meilsearchDetails${DateTime.now().toIso8601String()}';
  final movies = await getMeilisearchDvdDetails();
  await writeJsonFile(filename, () async => movies.toJson());
  await writeHtmlFile(filename, movies);
}

typedef JsonCallback = Future<String> Function();

Future<void> writeJsonFile(String filename, JsonCallback jsonGenerator) async {
  logger.w(
    'backup started at timestamp ${DateTime.now().millisecondsSinceEpoch}',
  );

  final data = await jsonGenerator();

  await File('$filename.json').writeAsString(data, flush: true);

  logger.w(
    'Backup written to $filename '
    'file size: ${data.length}',
  );
}

Future<void> writeHtmlFile(String filename, List<MovieResultDTO> movies) async {
  logger.w('Writing HTML to $filename ');
  final html = StringBuffer()..write(htmlHeader);
  movies.sort((m1, m2) => m1.year.compareTo(m2.year));
  html.write(jsonToHtml(movies.take(95)));
  movies.sort((m1, m2) => m2.year.compareTo(m1.year));
  html.write(jsonToHtml(movies.take(95)));
  movies.sort((m1, m2) => m2.userRatingCount.compareTo(m1.userRatingCount));
  html
    ..write(jsonToHtml(movies.take(50)))
    ..write(htmlFooter);

  await File('$filename.html').writeAsString(html.toString(), flush: true);
  logger.w('HTML size ${html.toString().length} ');
}

String jsonToHtml(Iterable<MovieResultDTO> movies) {
  final fb = MovieLocation();
  final html = StringBuffer();
  for (final movie in movies) {
    final locations = fb.getLocationsForMovie(movie.uniqueId);
    html
      ..write('<div class="image-container">\n')
      ..write('<img class="image-poster" '
          'src="${movie.imageUrl}" alt="${movie.title}">\n')
      ..write('<div class="image-text">${movie.title}</div>\n')
      ..write('<div class="stacker-locations">');
    for (final location in locations) {
      html.write('${location.libNum}:${location.location}, ');
    }
    html.write('</div>\n</div>\n');
  }
  return html.toString();
}

Future<Map<String, dynamic>> getFirebaseData({required bool clearCache}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final fb = MovieLocation();
  final data = await fb.getBackupData(clearCache: clearCache);

  logger.w('Database statistics: ${fb.statistics()}');
  return data;
}

Future<String> getMovieDetails() async {
  final movieDetails = <MovieResultDTO>[];
  WidgetsFlutterBinding.ensureInitialized();
  // Dont rely upon firebase backup for data.
  final movies = await getFirebaseData(clearCache: true);
  var recordNumber = 1;
  Settings().init();
  await Settings().cloudSettingsInitialised;

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
    final criteria = SearchCriteriaDTO()
      ..init(
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

  return movieDetails.toJson();
}

Future<List<MovieResultDTO>> getMeilisearchDvdDetails() async {
  final movieDetails = <MovieResultDTO>[];
  final futures = <Future<dynamic>>[];
  // Assume up to date firebase backup data.
  final movies = await getFirebaseData(clearCache: false);
  var recordNumber = 1;
  Settings().init();
  await Settings().cloudSettingsInitialised;

  final searchEngine = MeiliSearch(indexName: 'dvds');

  // Loop through each movie in the Firebase data.
  for (final uniqueId in movies.keys) {
    logger.w(
      'Fetching record ${recordNumber++} '
      'of ${movies.keys.length} uniqueId:$uniqueId',
    );

    // Fetch movie details from meilisearch.
    try {
      final doc = await searchEngine.getDocument(uniqueId);
      if (doc != null) {
        movieDetails.add(doc);
      }
    } catch (e) {
      logger.e(e);
    }
  }

  // Wait for all asynchronous operations to complete before returning.
  await Future.wait(futures);
  return movieDetails;
}

const htmlHeader = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Image Gallery</title>
  <style>
    @media print {
      /* Styles for printing */
      .image-container {
        border: 1mm solid black !important;  /* Thinner black border for cells */
      }
      .image-poster {
        page-break-after: avoid;  /* Discourage page break after the image */
      }
      .image-text {
        page-break-before: avoid;  /* Discourage page break before the text */
                font-size: 12px;
      }
      .stacker-locations {
          page-break-before: avoid;/* Discourage page break before the text */
          font-size: 12px;
      }
    }
    /* Styles for screen viewing */
    .image-grid {
      display: grid;
      grid-template-columns: repeat(5, 1fr);
      grid-gap: 10px;
      border: 2px solid #ddd;
    }
    .image-container {
      text-align: center;
      border: 1px solid #ddd;
      padding: 5px;
    }
    .image-container {
        text-align: center;
        border: 1px solid #ddd;
        padding: 5px;
    }
    .image-poster {
        max-height: 300px;
        max-width: 180px;
    }
    .stacker-locations {
        max-height: 50px;
    }
  </style>
<body>
  <div class="image-grid">''';
const htmlFooter = '''

  </div>
</body>
</html>''';
