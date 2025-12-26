import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_json.dart';

import '../test/test_helper.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
///     WebJsonExtractor uses a HeadlessInAppWebView
/// which requires a real android device or emulator to run
/// hence this is an integration test with a full MyApp widget.
///
/// Android device must be connected or launch from the command line with:
/// flutter test integration_test/web_fetch_imdb_json_paginated_integration_test.dart -d 192.168.0.33:41471
////////////////////////////////////////////////////////////////////////////////

// ignore_for_file: unnecessary_raw_strings

void main() {
  // Ensure the platform bindings are initialized for the integration test.
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
  ////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
  ////////////////////////////////////////////////////////////////////////////////

  group('live QueryIMDBJsonDetails test', () {
    // Convert 3 IMDB pages into dtos.
    test(
      'Run read 10 json queries from QueryIMDBJsonPaginatedFilmographyDetails',
      () async {
        final actualOutput = await _testRead(['nm0000233', 'nm0000149']);
        final sampleOutput = sampleTestData(
          actualOutput,
          relatedSampleQuantity: 5,
        );

        // To update expected data, uncomment the following lines
        /*printTestData(sampleOutput);
        print(actualOutput.first.related.values.first.length);
        print(actualOutput.last.related.values.first.length);*/
        final relatedLengths = <int>[
          actualOutput.first.related.values.first.length,
          actualOutput.last.related.values.first.length,
        ]..sort((a, b) => a.compareTo(b));

        final expectedOutput = expectedDTOList;
        // Check the results.
        expect(
          sampleOutput,
          MovieResultDTOListFuzzyMatcher(expectedOutput, percentMatch: 50),
          reason:
              'Emitted DTO list ${actualOutput.toPrintableString()} '
              'needs to match expected DTO list '
              '${expectedOutput.toPrintableString()}',
        );
        expect(
          relatedLengths.first,
          greaterThanOrEqualTo(17),
          reason:
              'Quinten should have 17 Actor credits but the data says '
              '${actualOutput.first.related.keys.first}:'
              '${actualOutput.first.related.values.first.length}',
        );
        expect(
          relatedLengths.last,
          greaterThanOrEqualTo(69),
          reason:
              'Jodie Foster should have 69 Actress credits but the data says '
              '${actualOutput.first.related.keys.first}:'
              '${actualOutput.last.related.values.first.length}',
        );
      },
      timeout: const Timeout(Duration(seconds: 60)),
      // This test uses flutter_inappwebview which is configured for Android.
      skip: !Platform.isAndroid,
    );
    test(
      'Run an empty QueryIMDBJsonPaginatedFilmographyDetails search',
      () async {
        final criteria = SearchCriteriaDTO().fromString(
          'therearenoresultszzzz',
        );
        final actualOutput = await QueryIMDBJsonPaginatedFilmographyDetails(
          criteria,
        ).readList(limit: 10);
        final expectedOutput = <MovieResultDTO>[];

        // Check the results.
        expect(
          actualOutput,
          MovieResultDTOListMatcher(expectedOutput),
          reason:
              'Emitted DTO list ${actualOutput.toPrintableString()} '
              'needs to match expected DTO list '
              '${expectedOutput.toPrintableString()}',
        );
      },
    );
  });
}

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

/// Call IMDB for each criteria in the list.
List<Future<List<MovieResultDTO>>> _queueDetailSearch(List<String> queries) {
  final List<Future<List<MovieResultDTO>>> futures =
      <Future<List<MovieResultDTO>>>[];
  for (final queryKey in queries) {
    final criteria = SearchCriteriaDTO().fromString(queryKey);
    // ignore: discarded_futures
    futures.add(QueryIMDBJsonPaginatedFilmographyDetails(criteria).readList());
  }
  return futures;
}

Future<List<MovieResultDTO>> _testRead(List<String> criteria) async {
  // Call IMDB for each criteria in the list.
  final futures = _queueDetailSearch(criteria);

  // Collect the result of all the IMDB queries.
  final queryResult = <MovieResultDTO>[];
  for (final future in futures) {
    queryResult.addAll(await future);
  }
  return queryResult;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Json Extractor Integration Test')),
      body: const MyWebViewWidget(),
    ),
  );
}

class MyWebViewWidget extends StatefulWidget {
  const MyWebViewWidget({super.key});

  @override
  State<MyWebViewWidget> createState() => _MyWebViewWidgetState();
}

class _MyWebViewWidgetState extends State<MyWebViewWidget> {
  @override
  Widget build(BuildContext context) => const Text('Json extractor');
}

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
r'''
{"uniqueId":"nm0000149","title":"Jodie Foster","bestSource":"DataSourceType.imdbJson","type":"MovieContentType.person","year":"1962","yearRange":"1962",
      "description":"Jodie Foster started her career at the age of two. For four years she made commercials and finally gave her debut as an actress in the TV series Mayberry R.F.D. (1968). In 1975 Jodie was offered the role of prostitute Iris Steensma in the movie Taxi Driver (1976). This role, for which she received an Academy Award nomination in the \"Best Supporting Actress\" category, marked a breakthrough in her career. In 1980 she graduated as the best of her class from the College Lycée Français and began to study English Literature at Yale University, from where she graduated magna cum laude in 1985. One tragic moment in her life was March 30th, 1981 when John Warnock Hinkley Jr. attempted to assassinate the President of the United States, Ronald Reagan. Hinkley was obsessed with Jodie and the movie Taxi Driver (1976), in which Travis Bickle, played by Robert De Niro, tried to shoot presidential candidate Palantine. Despite the fact that Jodie never took acting lessons, she received two Oscars before she was thirty years of age. She received her first award for her part as Sarah Tobias in The Accused (1988) and the second one for her performance as Clarice Starling in The Silence of the Lambs (1991).","userRatingCount":"597","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTM3MjgyOTQwNF5BMl5BanBnXkFtZTcwMDczMzEwNA@@._V1_.jpg","sources":{"DataSourceType.imdbJson":"nm0000149"},
  "related":{"Actress:":{"tt0046593":{"uniqueId":"tt0046593","title":"Disneyland","bestSource":"DataSourceType.imdbSuggestions","characterName":" [Annabel Andrews]","type":"MovieContentType.series","year":"1954","yearRange":"1954-1997","runTime":"7200",
      "genres":"[\"Adventure\",\"Drama\",\"Family\"]",
      "userRating":"8.4","userRatingCount":"2538","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BM2E0ZGVjYzMtOWYxYy00MDc4LWE2NWYtZWQwZmM3YmQ3NzU0XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0046593"}},
      "tt0047736":{"uniqueId":"tt0047736","title":"Gunsmoke","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","characterName":" [Patricia, Susan Sadler, Marieanne]","type":"MovieContentType.series","year":"1955","yearRange":"1955-1975","runTime":"3600",
      "genres":"[\"Western\"]",
      "userRating":"8.1","userRatingCount":"9930","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTcxMDcxODk2MF5BMl5BanBnXkFtZTcwMTM3MDU1MQ@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0047736"}},
      "tt0052451":{"uniqueId":"tt0052451","title":"Bonanza","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","characterName":" [Bluebird]","type":"MovieContentType.series","year":"1959","yearRange":"1959-1973","runTime":"2940",
      "genres":"[\"Western\"]",
      "userRating":"7.3","userRatingCount":"12287","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BN2QyM2FmMTAtYTQxNS00NTg3LTgzYWQtYTA3ODk0MDFkODhjXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0052451"}},
      "tt0053525":{"uniqueId":"tt0053525","title":"My Three Sons","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","characterName":" [Priscilla Hobson, Susan, Victoria]","type":"MovieContentType.series","year":"1960","yearRange":"1960-1972","runTime":"1800",
      "genres":"[\"Comedy\",\"Family\"]",
      "userRating":"7.1","userRatingCount":"4970","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzU4N2E2MWYtNGZhNi00ZDYwLTkxOGEtNWY3MWEyOTk5MDM5XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0053525"}},
      "tt0057742":{"uniqueId":"tt0057742","title":"Daniel Boone","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","characterName":" [Rachel Pickett]","type":"MovieContentType.series","year":"1964","yearRange":"1964-1970","runTime":"3600",
      "genres":"[\"Adventure\",\"Western\"]",
      "userRating":"7.3","userRatingCount":"2670","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTc5OTU5OTIzN15BMl5BanBnXkFtZTcwMDk1MTk5Mw@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0057742"}}},
    "Additional Crew:":{"tt0108185":{"uniqueId":"tt0108185","title":"Sommersby","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1993","yearRange":"1993","runTime":"6840",
      "genres":"[\"Drama\",\"Mystery\",\"Romance\"]",
      "userRating":"6.3","userRatingCount":"24460","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZGExZjZjYjUtZTRiNy00OGM2LTlkMDctMzZmNmRmMzc0ZGYzXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0108185"}},
      "tt0113247":{"uniqueId":"tt0113247","title":"La haine","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1995","yearRange":"1995","runTime":"5880",
      "genres":"[\"Crime\",\"Drama\"]",
      "userRating":"8.1","userRatingCount":"220595","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMThlMDA3NDYtZGM2Zi00NmJhLThlYWItZjViZTkzZWU1ZWRiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0113247"}}},
    "Cinematographer:":{"tt27626554":{"uniqueId":"tt27626554","title":"Hands of Time","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.short","year":"1978","yearRange":"1978",
      "genres":"[\"Documentary\",\"Short\"]","imageUrl":"https://m.media-amazon.com/images/M/MV5BOGQzODVmZTItMzk4Mi00MDUwLWFhNGUtZjVkMTkzYWI4NzJiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt27626554"}}},
    "Director:":{"tt0086814":{"uniqueId":"tt0086814","title":"Tales from the Darkside","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"1983","yearRange":"1983-1988","runTime":"1800",
      "genres":"[\"Comedy\",\"Drama\",\"Fantasy\"]",
      "userRating":"7.4","userRatingCount":"7455","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMWYwODdlMGQtODcyZS00ZTgwLWI5ZDQtMDYyY2RhNjkwMjRkXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0086814"}},
      "tt0102316":{"uniqueId":"tt0102316","title":"Little Man Tate","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1991","yearRange":"1991","runTime":"5940",
      "genres":"[\"Drama\"]",
      "userRating":"6.6","userRatingCount":"17504","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BZTk2ODRjMDYtZmVkNi00NjFlLWE0N2ItM2JiZjRkNDI2NGFmXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0102316"}},
      "tt0113321":{"uniqueId":"tt0113321","title":"Home for the Holidays","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1995","yearRange":"1995","runTime":"6180",
      "genres":"[\"Comedy\",\"Drama\",\"Romance\"]",
      "userRating":"6.6","userRatingCount":"16080","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMDI1ZmZhMDQtMDZkMC00M2VlLWJjZDMtYmEyMWRiMDIwZGJiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0113321"}},
      "tt1321860":{"uniqueId":"tt1321860","title":"The Beaver","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"2011","yearRange":"2011","runTime":"5460",
      "genres":"[\"Drama\"]",
      "userRating":"6.6","userRatingCount":"51994","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMzc0Nzc0MjA4OF5BMl5BanBnXkFtZTcwNTEyOTYxNA@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt1321860"}},
      "tt1856010":{"uniqueId":"tt1856010","title":"House of Cards","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"2013","yearRange":"2013-2018","runTime":"3000",
      "genres":"[\"Drama\",\"Thriller\"]",
      "userRating":"8.6","userRatingCount":"554564","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTQ4MDczNDYwNV5BMl5BanBnXkFtZTcwNjMwMDk5OA@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt1856010"}}},
    "Producer:":{"tt0091513":{"uniqueId":"tt0091513","title":"Mesmerized","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1985","yearRange":"1985","runTime":"5640",
      "genres":"[\"Drama\"]",
      "userRating":"4.7","userRatingCount":"1118","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BODA2NmM3M2ItY2Y2My00Mjk5LWFkYjEtODEyNTgyZmMyYTczXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0091513"}},
      "tt0110638":{"uniqueId":"tt0110638","title":"Nell","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1994","yearRange":"1994","runTime":"6720",
      "genres":"[\"Drama\"]",
      "userRating":"6.5","userRatingCount":"32239","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTkxY2NkMmItOTNmNy00NGU0LTlhM2UtOGQwNDhmNTBmNzQ3XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0110638"}},
      "tt0113321":{"uniqueId":"tt0113321","title":"Home for the Holidays","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1995","yearRange":"1995","runTime":"6180",
      "genres":"[\"Comedy\",\"Drama\",\"Romance\"]",
      "userRating":"6.6","userRatingCount":"16080","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMDI1ZmZhMDQtMDZkMC00M2VlLWJjZDMtYmEyMWRiMDIwZGJiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0113321"}},
      "tt0126802":{"uniqueId":"tt0126802","title":"The Baby Dance","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1998","yearRange":"1998","runTime":"5700",
      "genres":"[\"Drama\"]",
      "userRating":"6.5","userRatingCount":"500","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNzY2N2VlMTQtZTMxYi00ODM5LWFhNWItZTgxZWFjYzlkMjNkXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0126802"}},
      "tt0127349":{"uniqueId":"tt0127349","title":"Waking the Dead","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"2000","yearRange":"2000","runTime":"6300",
      "genres":"[\"Drama\",\"Mystery\",\"Romance\"]",
      "userRating":"6.4","userRatingCount":"7932","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNjRlMTczOGItNzU2ZS00ZTUxLWJkOWMtZmI1YTRkY2YwZTVkXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0127349"}}},
    "Self:":{"tt0044298":{"uniqueId":"tt0044298","title":"Today","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","characterName":" [Self - Guest]","type":"MovieContentType.series","year":"1952","yearRange":"1952","runTime":"14400",
      "genres":"[\"News\",\"Talk-Show\"]",
      "userRating":"4.6","userRatingCount":"2653","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BY2I3NWI5M2EtNDE5Yi00ZDNjLTk0OGMtMDA0OWM5ODQ0Y2Y5XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0044298"}},
      "tt0055708":{"uniqueId":"tt0055708","title":"Late Night with Johnny Carson","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" The Tonight Show Starring Johnny Carson","characterName":" [Self]","type":"MovieContentType.series","year":"1962","yearRange":"1962-1992","runTime":"6300",
      "genres":"[\"Comedy\",\"Talk-Show\"]",
      "userRating":"8.5","userRatingCount":"4564","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNjc2NzY5ZmMtZjAxNi00MDE1LThmZjktNTdlNTE4NzUzNTc1XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0055708"}},
      "tt0063951":{"uniqueId":"tt0063951","title":"Sesame Street","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","characterName":" [Self]","type":"MovieContentType.episode","year":"1969","yearRange":"1969","runTime":"3300",
      "genres":"[\"Animation\",\"Adventure\",\"Comedy\"]",
      "userRating":"8.1","userRatingCount":"16792","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTNjOTk2YmUtYjNhZC00MTM3LTg0MGItYWI5Y2I2N2FhYjU4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0063951"}},
      "tt0072490":{"uniqueId":"tt0072490","title":"The Dick Cavett Show","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","characterName":" [Self - Iris]","type":"MovieContentType.series","year":"1975","yearRange":"1975-1982","runTime":"1800",
      "genres":"[\"Talk-Show\"]",
      "userRating":"7.9","userRatingCount":"290","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTM0MDkzMDIyMF5BMl5BanBnXkFtZTcwNjYxOTAzMQ@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0072490"}},
      "tt0072506":{"uniqueId":"tt0072506","title":"Good Morning America","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","characterName":" [Self - Guest]","type":"MovieContentType.series","year":"1975","yearRange":"1975","runTime":"7200",
      "genres":"[\"News\",\"Talk-Show\"]",
      "userRating":"4.4","userRatingCount":"2227","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BMGFiMzllZjItN2YxMy00MDcwLWEwZjEtMWQ0MDUzYzJkNTQ2XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0072506"}}},
    "Soundtrack:":{"tt0047736":{"uniqueId":"tt0047736","title":"Gunsmoke","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"1955","yearRange":"1955-1975","runTime":"3600",
      "genres":"[\"Western\"]",
      "userRating":"8.1","userRatingCount":"9930","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTcxMDcxODk2MF5BMl5BanBnXkFtZTcwMTM3MDU1MQ@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0047736"}},
      "tt0076054":{"uniqueId":"tt0076054","title":"Freaky Friday","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1976","yearRange":"1976","runTime":"5880",
      "genres":"[\"Comedy\",\"Family\",\"Fantasy\"]",
      "userRating":"6.3","userRatingCount":"15489","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BY2MyNDExNzAtNWY1ZC00NDJmLWIxZWMtNzgxYWVjMmUzYTBiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0076054"}},
      "tt0076401":{"uniqueId":"tt0076401","title":"Moi, Fleur bleue","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1977","yearRange":"1977","runTime":"6000",
      "genres":"[\"Comedy\",\"Drama\",\"Romance\"]",
      "userRating":"4.8","userRatingCount":"232","imageUrl":"https://m.media-amazon.com/images/M/MV5BYjIxZDA4NmEtMzlhYS00ZTA5LTgxMGUtNDgxODM1YWU1MGU5XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0076401"}},
      "tt0353132":{"uniqueId":"tt0353132","title":"46th Annual Academy Awards","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"1974","yearRange":"1974",
      "genres":"[\"Family\"]",
      "userRating":"6.1","userRatingCount":"185","imageUrl":"https://m.media-amazon.com/images/M/MV5BODAyOTljMWUtNGExYS00ZTAxLWFjZGMtMjYxYzRlZmUzODQ2XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0353132"}},
      "tt10954984":{"uniqueId":"tt10954984","title":"Nope","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"2022","yearRange":"2022","runTime":"7800",
      "genres":"[\"Horror\",\"Mystery\",\"Sci-Fi\"]",
      "userRating":"6.8","userRatingCount":"310002","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BODRlNWRhZWUtMzdlZC00ZDIyLWFhZjMtYTcxNjI1ZDIwODhjXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt10954984"}}},
    "Thanks:":{"tt0107232":{"uniqueId":"tt0107232","title":"It Was a Wonderful Life","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1992","yearRange":"1992","runTime":"4920",
      "genres":"[\"Documentary\"]",
      "userRating":"7.2","userRatingCount":"158","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTM2NTM0MTEzOV5BMl5BanBnXkFtZTcwMjg4NzUyMQ@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0107232"}},
      "tt0107233":{"uniqueId":"tt0107233","title":"It's All True: Based on an Unfinished Film by Orson Welles","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1993","yearRange":"1993","runTime":"5220",
      "genres":"[\"Documentary\"]",
      "userRating":"7.1","userRatingCount":"910","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BM2QwZDNlNTktYjMyMC00Njc1LTk0ZTUtNTAxZjU1NDk3NjVmXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0107233"}},
      "tt0111486":{"uniqueId":"tt0111486","title":"Trevor","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.short","year":"1994","yearRange":"1994","runTime":"1380",
      "genres":"[\"Short\",\"Comedy\",\"Drama\"]",
      "userRating":"7.7","userRatingCount":"1683","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BN2Y4ZTFiYzAtYWEyNy00NjZjLWI0MDMtZmQ3NjIwMmNhNzJiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0111486"}},
      "tt0166277":{"uniqueId":"tt0166277","title":"Movies Are My Life","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1978","yearRange":"1978","runTime":"3600",
      "genres":"[\"Documentary\"]",
      "userRating":"6.8","userRatingCount":"65","imageUrl":"https://m.media-amazon.com/images/M/MV5BYzJmZTExYjAtMjQ4Ni00YzM2LWFkODctN2QzYjQxOGJhNzFkXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0166277"}},
      "tt0276370":{"uniqueId":"tt0276370","title":"Ode","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.episode","year":"1999","yearRange":"1999","runTime":"2880",
      "genres":"[\"Drama\",\"Romance\"]",
      "userRating":"6.6","userRatingCount":"255","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjc0NzYzOTAtNzYwNy00YzYwLWIwZjctNWUzZDBhZjY4NjJlXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0276370"}}},
    "Writer:":{"tt27626554":{"uniqueId":"tt27626554","title":"Hands of Time","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.short","year":"1978","yearRange":"1978",
      "genres":"[\"Documentary\",\"Short\"]","imageUrl":"https://m.media-amazon.com/images/M/MV5BOGQzODVmZTItMzk4Mi00MDUwLWFhNGUtZjVkMTkzYWI4NzJiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt27626554"}}}}}
''',
r'''
{"uniqueId":"nm0000233","title":"Quentin Tarantino","bestSource":"DataSourceType.imdbJson","type":"MovieContentType.person","year":"1963","yearRange":"1963",
      "description":"Quentin Jerome Tarantino was born in Knoxville, Tennessee. His father, Tony Tarantino, is an Italian-American actor and musician from New York, and his mother, Connie (McHugh), is a nurse from Tennessee. Quentin moved with his mother to Torrance, California, when he was four years old.\n\nIn January of 1992, first-time writer-director Tarantino's Reservoir Dogs (1992) appeared at the Sundance Film Festival. The film garnered critical acclaim and the director became a legend immediately. Two years later, he followed up Dogs success with Pulp Fiction (1994) which premiered at the Cannes film festival, winning the coveted Palme D'Or Award. At the 1995 Academy Awards, it was nominated for the best picture, best director and best original screenplay. Tarantino and writing partner Roger Avary came away with the award only for best original screenplay. In 1995, Tarantino directed one fourth of the anthology Four Rooms (1995) with friends and fellow auteurs Alexandre Rockwell, Robert Rodriguez and Allison Anders. The film opened December 25 in the United States to very weak reviews. Tarantino's next film was From Dusk Till Dawn (1996), a vampire/crime story which he wrote and co-starred with George Clooney. The film did fairly well theatrically.\n\nSince then, Tarantino has helmed several critically and financially successful films, including Jackie Brown (1997), Kill Bill: Vol. 1 (2003), Kill Bill: Vol. 2 (2004), Inglourious Basterds (2009), Django Unchained (2012) and The Hateful Eight (2015).","userRatingCount":"144","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTgyMjI3ODA3Nl5BMl5BanBnXkFtZTcwNzY2MDYxOQ@@._V1_.jpg","sources":{"DataSourceType.imdbJson":"nm0000233"},
  "related":{"Actor:":{"tt0072562":{"uniqueId":"tt0072562","title":"Saturday Night Live","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","characterName":" [Camper, Chester Millbrush, Self - Guest Host]","type":"MovieContentType.custom","year":"1975","yearRange":"1975","runTime":"5400",
      "genres":"[\"Comedy\",\"Music\"]",
      "userRating":"8.0","userRatingCount":"56855","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BOGI0ODc4MjAtZDA4Mi00ZGUyLTg2NmItYzhmZTJiYjM5Mjc1XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0072562"}},
      "tt0088526":{"uniqueId":"tt0088526","title":"The Golden Girls","bestSource":"DataSourceType.imdbSuggestions","characterName":" [Elvis Impersonator]","type":"MovieContentType.series","year":"1985","yearRange":"1985-1992","runTime":"1800",
      "genres":"[\"Comedy\",\"Drama\"]",
      "userRating":"8.2","userRatingCount":"51857","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BOGM0ODkzNWUtYjIxNC00ZTdlLTg1MGEtNmExNjQ0YmYxZGFkXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0088526"}},
      "tt0105236":{"uniqueId":"tt0105236","title":"Reservoir Dogs","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","characterName":" [Mr. Brown]","type":"MovieContentType.movie","year":"1992","yearRange":"1992","runTime":"5940",
      "genres":"[\"Crime\",\"Thriller\"]",
      "userRating":"8.3","userRatingCount":"1156132","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BMmMzYjg4NDctYWY0Mi00OGViLWIzMTMtYWNlZGY5ZDJmYjk3XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0105236"}},
      "tt0106793":{"uniqueId":"tt0106793","title":"Eddie Presley","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","characterName":" [Asylum Attendant]","type":"MovieContentType.movie","year":"1992","yearRange":"1992","runTime":"6360",
      "genres":"[\"Comedy\",\"Drama\"]",
      "userRating":"5.4","userRatingCount":"365","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjE2NDUxMjI4NF5BMl5BanBnXkFtZTcwMjk2NzUyMQ@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0106793"}},
      "tt0108693":{"uniqueId":"tt0108693","title":"All-American Girl","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","characterName":" [Desmond]","type":"MovieContentType.series","year":"1994","yearRange":"1994-1995","runTime":"1800",
      "genres":"[\"Comedy\"]",
      "userRating":"6.8","userRatingCount":"572","imageUrl":"https://m.media-amazon.com/images/M/MV5BMTc3ODM0NjYyMF5BMl5BanBnXkFtZTcwMTUxNjkzMQ@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0108693"}}},
    "Additional Crew:":{"tt0105108":{"uniqueId":"tt0105108","title":"Past Midnight","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1991","yearRange":"1991","runTime":"6000",
      "genres":"[\"Drama\",\"Mystery\",\"Romance\"]",
      "userRating":"5.6","userRatingCount":"1702","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BMDUyNmIwYmYtMTVmYS00YTgyLWE0NjEtODBiMGNiN2ZjYjgyXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0105108"}},
      "tt0119396":{"uniqueId":"tt0119396","title":"Jackie Brown","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1997","yearRange":"1997","runTime":"9240",
      "genres":"[\"Crime\",\"Drama\",\"Thriller\"]",
      "userRating":"7.5","userRatingCount":"398471","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZmUxZjY3MDktNGI5NS00MTQ5LWE0YWItZWQzNmZhNjhkZDYyXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0119396"}},
      "tt0120695":{"uniqueId":"tt0120695","title":"From Dusk Till Dawn 3: The Hangman's Daughter","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1999","yearRange":"1999","runTime":"5640",
      "genres":"[\"Horror\",\"Thriller\",\"Western\"]",
      "userRating":"4.8","userRatingCount":"13352","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BMGJlMDkzMDAtMDhkYy00YjBmLWEzZjktYzZjNmQ4MTQ5Yjk4XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0120695"}},
      "tt0299977":{"uniqueId":"tt0299977","title":"Hero","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":"Ying xiong","type":"MovieContentType.movie","year":"2002","yearRange":"2002","runTime":"6420",
      "genres":"[\"Action\",\"Adventure\",\"Drama\"]",
      "userRating":"7.9","userRatingCount":"192825","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BYTlkZWVjYzQtZmI1My00MGM2LTlmZjEtNjU1M2Y1MTRkNmZjXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0299977"}},
      "tt0347591":{"uniqueId":"tt0347591","title":"My Name Is Modesty: A Modesty Blaise Adventure","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"2004","yearRange":"2004","runTime":"4680",
      "genres":"[\"Action\",\"Crime\",\"Drama\"]",
      "userRating":"4.6","userRatingCount":"2639","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BODM2NDY4MjIzNF5BMl5BanBnXkFtZTcwNTA1MTcyMQ@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0347591"}}},
    "Cinematographer:":{"tt0462322":{"uniqueId":"tt0462322","title":"Grindhouse","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"2007","yearRange":"2007","runTime":"11460",
      "genres":"[\"Horror\",\"Thriller\"]",
      "userRating":"7.5","userRatingCount":"195944","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjA0MzExNzc3MV5BMl5BanBnXkFtZTcwODAxMzM0MQ@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0462322"}},
      "tt1028528":{"uniqueId":"tt1028528","title":"Death Proof","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"2007","yearRange":"2007","runTime":"7620",
      "genres":"[\"Drama\",\"Thriller\"]",
      "userRating":"7.0","userRatingCount":"330563","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BYjRlOTM0OTktZTBjNi00ZjZiLWJkMzktMmU2ZDBkMTQxN2FmXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt1028528"}},
      "tt6493238":{"uniqueId":"tt6493238","title":"Reservoir Dogs: Sundance Institute 1991 June Film Lab","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.short","year":"1991","yearRange":"1991","runTime":"720",
      "genres":"[\"Short\",\"Drama\"]",
      "userRating":"6.4","userRatingCount":"1186","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTJlYzNhMDctZTc1MC00OWE4LWExZTItZDIzZTlhZDM1YTYwXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt6493238"}}},
    "Director:":{"tt0105236":{"uniqueId":"tt0105236","title":"Reservoir Dogs","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1992","yearRange":"1992","runTime":"5940",
      "genres":"[\"Crime\",\"Thriller\"]",
      "userRating":"8.3","userRatingCount":"1156132","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BMmMzYjg4NDctYWY0Mi00OGViLWIzMTMtYWNlZGY5ZDJmYjk3XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0105236"}},
      "tt0108757":{"uniqueId":"tt0108757","title":"ER","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.series","year":"1994","yearRange":"1994-2009","runTime":"2640",
      "genres":"[\"Drama\",\"Romance\"]",
      "userRating":"7.9","userRatingCount":"75220","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMzM5NjQ4M2QtNWQyMy00OWUxLWIyZjktNmY2ZjMyZjA2NWE0XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0108757"}},
      "tt0110912":{"uniqueId":"tt0110912","title":"Pulp Fiction","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1994","yearRange":"1994","runTime":"9240",
      "genres":"[\"Crime\",\"Drama\"]",
      "userRating":"8.8","userRatingCount":"2395761","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BYTViYTE3ZGQtNDBlMC00ZTAyLTkyODMtZGRiZDg0MjA2YThkXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0110912"}},
      "tt0113101":{"uniqueId":"tt0113101","title":"Four Rooms","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1995","yearRange":"1995","runTime":"5880",
      "genres":"[\"Comedy\"]",
      "userRating":"6.7","userRatingCount":"115836","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMmNlMjE5YTEtZTU1My00MDc1LTgwNzctNTZlYmJmNTM3ZjYzXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0113101"}},
      "tt0119396":{"uniqueId":"tt0119396","title":"Jackie Brown","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1997","yearRange":"1997","runTime":"9240",
      "genres":"[\"Crime\",\"Drama\",\"Thriller\"]",
      "userRating":"7.5","userRatingCount":"398471","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZmUxZjY3MDktNGI5NS00MTQ5LWE0YWItZWQzNmZhNjhkZDYyXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0119396"}}},
    "Editor:":{"tt0359715":{"uniqueId":"tt0359715","title":"My Best Friend's Birthday","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1987","yearRange":"1987","runTime":"4140",
      "genres":"[\"Comedy\"]",
      "userRating":"5.5","userRatingCount":"5043","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BMWRmZDc5NDctZmM5Zi00Mjg2LWJhODEtZWE4NWE1NzY3MzY5XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0359715"}},
      "tt6493238":{"uniqueId":"tt6493238","title":"Reservoir Dogs: Sundance Institute 1991 June Film Lab","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.short","year":"1991","yearRange":"1991","runTime":"720",
      "genres":"[\"Short\",\"Drama\"]",
      "userRating":"6.4","userRatingCount":"1186","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTJlYzNhMDctZTc1MC00OWE4LWExZTItZDIzZTlhZDM1YTYwXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt6493238"}}},
    "Music Department:":{"tt0266697":{"uniqueId":"tt0266697","title":"Kill Bill: Vol. 1","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"2003","yearRange":"2003","runTime":"6660",
      "genres":"[\"Action\",\"Crime\",\"Thriller\"]",
      "userRating":"8.2","userRatingCount":"1284051","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BZmMyYzJlZmYtY2I3NC00NjAyLTkyZWItZjdjZDI1YTYyYTEwXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0266697"}},
      "tt0378194":{"uniqueId":"tt0378194","title":"Kill Bill: Vol. 2","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"2004","yearRange":"2004","runTime":"8220",
      "genres":"[\"Action\",\"Crime\",\"Thriller\"]",
      "userRating":"8.0","userRatingCount":"856698","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BY2FiNzhiZTctNzU1Mi00NDkwLWExNDMtZTg0MjYyNzhkNWNkXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0378194"}}},
    "Producer:":{"tt0105108":{"uniqueId":"tt0105108","title":"Past Midnight","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1991","yearRange":"1991","runTime":"6000",
      "genres":"[\"Drama\",\"Mystery\",\"Romance\"]",
      "userRating":"5.6","userRatingCount":"1702","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BMDUyNmIwYmYtMTVmYS00YTgyLWE0NjEtODBiMGNiN2ZjYjgyXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0105108"}},
      "tt0108148":{"uniqueId":"tt0108148","title":"Iron Monkey","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":"Siu nin Wong Fei Hung chi: Tit ma lau","type":"MovieContentType.movie","year":"1993","yearRange":"1993","runTime":"5400",
      "genres":"[\"Action\",\"Crime\",\"Drama\"]",
      "userRating":"7.5","userRatingCount":"17968","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BOWE2NzA1YTAtNmIwMi00ZjhlLTg2YTYtZGZlMDdlNjJiZWJkXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0108148"}},
      "tt0110265":{"uniqueId":"tt0110265","title":"Killing Zoe","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1993","yearRange":"1993","runTime":"5760",
      "genres":"[\"Crime\",\"Drama\",\"Thriller\"]",
      "userRating":"6.4","userRatingCount":"22331","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BOGU1MmI3MzUtNzM5OC00MGZjLWJiNjktNTg0MjYxMjlhNmIxXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0110265"}},
      "tt0113101":{"uniqueId":"tt0113101","title":"Four Rooms","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1995","yearRange":"1995","runTime":"5880",
      "genres":"[\"Comedy\"]",
      "userRating":"6.7","userRatingCount":"115836","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMmNlMjE5YTEtZTU1My00MDc1LTgwNzctNTZlYmJmNTM3ZjYzXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0113101"}},
      "tt0115994":{"uniqueId":"tt0115994","title":"Curdled","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1996","yearRange":"1996","runTime":"5280",
      "genres":"[\"Comedy\",\"Crime\",\"Thriller\"]",
      "userRating":"5.9","userRatingCount":"5842","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZWU1MzQ3ZDktNmI4Yi00MTYyLWFmOGUtZGE5YmNjMTJjM2I1XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0115994"}}},
    "Production Department:":{"tt0256188":{"uniqueId":"tt0256188","title":"Maximum Potential","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.episode","year":"1987","yearRange":"1987","runTime":"3120",
      "genres":"[\"Sport\"]",
      "userRating":"6.6","userRatingCount":"196","imageUrl":"https://m.media-amazon.com/images/M/MV5BNDY0NGRjYTUtNTY1Mi00NTUwLWIwOGItZGZjYzFhNDAzZjhiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0256188"}}},
    "Script and Continuity Department:":{"tt0110169":{"uniqueId":"tt0110169","title":"It's Pat: The Movie","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1994","yearRange":"1994","runTime":"4620",
      "genres":"[\"Comedy\"]",
      "userRating":"2.8","userRatingCount":"10771","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BOWI5YTU1NmQtODQ0Mi00NzY4LWE0MjUtMDdkYzQxYmY1YTg3XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0110169"}},
      "tt0112740":{"uniqueId":"tt0112740","title":"Crimson Tide","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1995","yearRange":"1995","runTime":"6960",
      "genres":"[\"Action\",\"Drama\",\"Thriller\"]",
      "userRating":"7.4","userRatingCount":"134200","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTNhZDk2NmQtNDc3ZC00Nzk3LWFmNTctYTc0OWMyNGM0ZWYyXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0112740"}},
      "tt0117500":{"uniqueId":"tt0117500","title":"The Rock","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1996","yearRange":"1996","runTime":"8160",
      "genres":"[\"Action\",\"Adventure\",\"Thriller\"]",
      "userRating":"7.4","userRatingCount":"376166","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BMDhkYjRiZWEtZTE0Ny00ZjA1LThmNjgtM2UyYTQzODA4MjdhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0117500"}}},
    "Self:":{"tt0044298":{"uniqueId":"tt0044298","title":"Today","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","characterName":" [Self - Guest]","type":"MovieContentType.series","year":"1952","yearRange":"1952","runTime":"14400",
      "genres":"[\"News\",\"Talk-Show\"]",
      "userRating":"4.6","userRatingCount":"2653","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BY2I3NWI5M2EtNDE5Yi00ZDNjLTk0OGMtMDA0OWM5ODQ0Y2Y5XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0044298"}},
      "tt0073989":{"uniqueId":"tt0073989","title":"Extra Drei","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","characterName":" [Self]","type":"MovieContentType.series","year":"1976","yearRange":"1976",
      "genres":"[\"Comedy\",\"News\"]",
      "userRating":"7.5","userRatingCount":"480","imageUrl":"https://m.media-amazon.com/images/M/MV5BNTEyNGYyNzktMDAyNy00OGVhLTg4MWQtYjAzNTdkMjJjNTlhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0073989"}},
      "tt0081857":{"uniqueId":"tt0081857","title":"Entertainment Tonight","bestSource":"DataSourceType.imdbSuggestions","characterName":" [Self]","type":"MovieContentType.series","year":"1981","yearRange":"1981","runTime":"1800",
      "genres":"[\"News\",\"Talk-Show\"]",
      "userRating":"3.6","userRatingCount":"3008","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BYmEzODg2ZjctZDIzMC00ZjE4LTg2M2UtMjI5ZmJhYWRmMjFkXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0081857"}},
      "tt0088550":{"uniqueId":"tt0088550","title":"Larry King Live","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","characterName":" [Self - Guest]","type":"MovieContentType.series","year":"1985","yearRange":"1985-2010","runTime":"3600",
      "genres":"[\"News\",\"Talk-Show\"]",
      "userRating":"5.5","userRatingCount":"1305","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZjM3NzFmMDgtOWVjZS00YmJiLTk3YjAtZThkZGEwOTNlNzNhXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0088550"}},
      "tt0092322":{"uniqueId":"tt0092322","title":"Biography","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":" ","characterName":" [Self]","type":"MovieContentType.series","year":"1987","yearRange":"1987","runTime":"3600",
      "genres":"[\"Documentary\",\"Biography\",\"History\"]",
      "userRating":"7.7","userRatingCount":"2180","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BZTEwNjU0OTgtNDQ3OC00NTJhLTg1OTktNGM2ODM4MTU1MmExXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0092322"}}},
    "Soundtrack:":{"tt0072562":{"uniqueId":"tt0072562","title":"Saturday Night Live","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.custom","year":"1975","yearRange":"1975","runTime":"5400",
      "genres":"[\"Comedy\",\"Music\"]",
      "userRating":"8.0","userRatingCount":"56855","censorRating":"CensorRatingType.family","imageUrl":"https://m.media-amazon.com/images/M/MV5BOGI0ODc4MjAtZDA4Mi00ZGUyLTg2NmItYzhmZTJiYjM5Mjc1XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0072562"}},
      "tt0378194":{"uniqueId":"tt0378194","title":"Kill Bill: Vol. 2","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"2004","yearRange":"2004","runTime":"8220",
      "genres":"[\"Action\",\"Crime\",\"Thriller\"]",
      "userRating":"8.0","userRatingCount":"856698","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BY2FiNzhiZTctNzU1Mi00NDkwLWExNDMtZTg0MjYyNzhkNWNkXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0378194"}},
      "tt1853728":{"uniqueId":"tt1853728","title":"Django Unchained","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"2012","yearRange":"2012","runTime":"9900",
      "genres":"[\"Drama\",\"Western\"]",
      "userRating":"8.5","userRatingCount":"1848410","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMjIyNTQ5NjQ1OV5BMl5BanBnXkFtZTcwODg1MDU4OA@@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt1853728"}},
      "tt6019206":{"uniqueId":"tt6019206","title":"Kill Bill: The Whole Bloody Affair","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"2006","yearRange":"2006","runTime":"16500",
      "genres":"[\"Action\",\"Crime\",\"Thriller\"]",
      "userRating":"8.8","userRatingCount":"24344","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDc2YzhkODAtZmRmZS00YzcxLWJkYWEtM2ZhZjY3MmMyZmJiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt6019206"}}},
    "Thanks:":{"tt0114928":{"uniqueId":"tt0114928","title":"White Man's Burden","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1995","yearRange":"1995","runTime":"5340",
      "genres":"[\"Drama\",\"Thriller\"]",
      "userRating":"5.3","userRatingCount":"5363","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BN2FmZjFjNDAtODI2Zi00YmQxLTkxZDMtZjcxYzQ1NmQyZmFiXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0114928"}},
      "tt0119165":{"uniqueId":"tt0119165","title":"Full Tilt Boogie","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1997","yearRange":"1997","runTime":"5820",
      "genres":"[\"Documentary\"]",
      "userRating":"6.6","userRatingCount":"2990","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMWQ0M2IwZjMtOWY0ZC00ZjU2LWIxNWQtYjA1MDVmYTRiNzEzXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0119165"}},
      "tt0120655":{"uniqueId":"tt0120655","title":"Dogma","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1999","yearRange":"1999","runTime":"7800",
      "genres":"[\"Adventure\",\"Comedy\",\"Drama\"]",
      "userRating":"7.3","userRatingCount":"238167","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BNDE1Yjc3N2UtZmYwNi00YTA3LTllNGEtZTIwODg2MmMwNjBjXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0120655"}},
      "tt0157016":{"uniqueId":"tt0157016","title":"I Stand Alone","bestSource":"DataSourceType.imdbSuggestions","alternateTitle":"Seul contre tous","type":"MovieContentType.movie","year":"1998","yearRange":"1998","runTime":"5580",
      "genres":"[\"Crime\",\"Drama\",\"Thriller\"]",
      "userRating":"7.3","userRatingCount":"27345","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BOTU2ZTdhMDctZTcxNS00OWUwLWFmYWQtOWFkMTYxNTZiM2QxXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0157016"}},
      "tt0203169":{"uniqueId":"tt0203169","title":"Together & Alone","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1998","yearRange":"1998","runTime":"5040",
      "genres":"[\"Comedy\",\"Drama\"]",
      "userRating":"7.0","userRatingCount":"74","imageUrl":"https://m.media-amazon.com/images/M/MV5BOGNjYjYwMTAtMzY2MS00OGIwLTg3ZTctZGQ1MDViZjc0MDU3XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0203169"}}},
    "Writer:":{"tt0105236":{"uniqueId":"tt0105236","title":"Reservoir Dogs","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1992","yearRange":"1992","runTime":"5940",
      "genres":"[\"Crime\",\"Thriller\"]",
      "userRating":"8.3","userRatingCount":"1156132","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BMmMzYjg4NDctYWY0Mi00OGViLWIzMTMtYWNlZGY5ZDJmYjk3XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0105236"}},
      "tt0108399":{"uniqueId":"tt0108399","title":"True Romance","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1993","yearRange":"1993","runTime":"7140",
      "genres":"[\"Crime\",\"Drama\",\"Romance\"]",
      "userRating":"7.9","userRatingCount":"257835","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BYzQ5OGMwMDAtMzcyOS00YTA4LWEwM2MtOTA1MDZjZGEyYmI1XkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0108399"}},
      "tt0110632":{"uniqueId":"tt0110632","title":"Natural Born Killers","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1994","yearRange":"1994","runTime":"7140",
      "genres":"[\"Crime\",\"Romance\"]",
      "userRating":"7.2","userRatingCount":"265056","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BNjJkNzIxNGUtOWZjOC00YjJkLTljNDUtZThkM2JkOTUzMDJkXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0110632"}},
      "tt0110912":{"uniqueId":"tt0110912","title":"Pulp Fiction","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1994","yearRange":"1994","runTime":"9240",
      "genres":"[\"Crime\",\"Drama\"]",
      "userRating":"8.8","userRatingCount":"2395761","censorRating":"CensorRatingType.restricted","imageUrl":"https://m.media-amazon.com/images/M/MV5BYTViYTE3ZGQtNDBlMC00ZTAyLTkyODMtZGRiZDg0MjA2YThkXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0110912"}},
      "tt0113101":{"uniqueId":"tt0113101","title":"Four Rooms","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.movie","year":"1995","yearRange":"1995","runTime":"5880",
      "genres":"[\"Comedy\"]",
      "userRating":"6.7","userRatingCount":"115836","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BMmNlMjE5YTEtZTU1My00MDc1LTgwNzctNTZlYmJmNTM3ZjYzXkEyXkFqcGc@._V1_.jpg","sources":{"DataSourceType.imdbSuggestions":"tt0113101"}}}}}
''',
];
