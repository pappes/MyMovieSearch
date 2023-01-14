import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_search.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings
////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt0376554","bestSource":"DataSourceType.imdbSearch","title":"Danehaye rize barf","type":"MovieContentType.movie","year":"2003","yearRange":"2003","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [Madjid Bahrami, Mohsen Tanabandeh]","imageUrl":"https://m.media-amazon.com/images/M/MV5BYzVlZjdiYzAtODU5NC00NDg1LTk2YmQtZWI5MzlmM2IwN2M5XkEyXkFqcGdeQXVyNDQ3OTQ2MTY@._V1_.jpg","sources":{"DataSourceType.imdbSearch":"tt0376554"},"related":{}}
''',
  r'''
{"uniqueId":"tt0436724","bestSource":"DataSourceType.imdbSearch","title":"Rize","type":"MovieContentType.movie","year":"2005","yearRange":"2005","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [Tommy the Clown, Larry Berry]","imageUrl":"https://m.media-amazon.com/images/M/MV5BZDNkZWZiMjMtNTY0Ni00Yjg0LWFlNjctNTRhMTI3MTU5ZjE2XkEyXkFqcGdeQXVyMTY5Nzc4MDY@._V1_.jpg","sources":{"DataSourceType.imdbSearch":"tt0436724"},"related":{}}
''',
  r'''
{"uniqueId":"tt13345606","bestSource":"DataSourceType.imdbSearch","title":"Evil Dead Rise","type":"MovieContentType.movie","year":"2023","yearRange":"2023","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [Alyssa Sutherland, Lily Sullivan]","imageUrl":"https://m.media-amazon.com/images/M/MV5BMmZiN2VmMjktZDE5OC00ZWRmLWFlMmEtYWViMTY4NjM3ZmNkXkEyXkFqcGdeQXVyMTI2MTc2ODM3._V1_.jpg","sources":{"DataSourceType.imdbSearch":"tt13345606"},"related":{}}
''',
  r'''
{"uniqueId":"tt24637510","bestSource":"DataSourceType.imdbSearch","title":"Rize","type":"MovieContentType.series","yearRange":"2022– ","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring []","sources":{"DataSourceType.imdbSearch":"tt24637510"},"related":{}}
''',
  r'''
{"uniqueId":"tt3166426","bestSource":"DataSourceType.imdbSearch","title":"Die-Rize","type":"MovieContentType.movie","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [Lisa May, Cristina Trevino]","sources":{"DataSourceType.imdbSearch":"tt3166426"},"related":{}}
''',
  r'''
{"uniqueId":"tt5363184","bestSource":"DataSourceType.imdbSearch","title":"Rize Action","type":"MovieContentType.movie","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring []","sources":{"DataSourceType.imdbSearch":"tt5363184"},"related":{}}
''',
  r'''
{"uniqueId":"tt7529532","bestSource":"DataSourceType.imdbSearch","title":"Tenacious D: Rize of the Fenix","type":"MovieContentType.custom","year":"2012","yearRange":"2012","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [Jack Black, Steve Clemmons]","imageUrl":"https://m.media-amazon.com/images/M/MV5BZmNiZmJlYTktMDY2NC00YTlkLTlhOTMtNDZlNzA2YzFmMzcxXkEyXkFqcGdeQXVyNjE4NDU1Njk@._V1_.jpg","sources":{"DataSourceType.imdbSearch":"tt7529532"},"related":{}}
''',
  r'''
{"uniqueId":"tt8067018","bestSource":"DataSourceType.imdbSearch","title":"The Rize & Fall of Tephlon Ent","type":"MovieContentType.movie","year":"2016","yearRange":"2016","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [Emmanuel Kulu]","imageUrl":"https://m.media-amazon.com/images/M/MV5BOTJhNjAwOWQtNTlkMS00MjVkLTgwZmYtYThjZmMwNjg3MTRkXkEyXkFqcGdeQXVyODU4ODIwNzU@._V1_.jpg","sources":{"DataSourceType.imdbSearch":"tt8067018"},"related":{}}
''',
  r'''
{"uniqueId":"tt8178634","bestSource":"DataSourceType.imdbSearch","title":"RRR (Rise Roar Revolt)","type":"MovieContentType.movie","year":"2022","yearRange":"2022","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [N.T. Rama Rao Jr., Ram Charan Teja]","imageUrl":"https://m.media-amazon.com/images/M/MV5BODUwNDNjYzctODUxNy00ZTA2LWIyYTEtMDc5Y2E5ZjBmNTMzXkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_.jpg","sources":{"DataSourceType.imdbSearch":"tt8178634"},"related":{}}
''',
  r'''
{"uniqueId":"tt9244578","bestSource":"DataSourceType.imdbSearch","title":"Rise of Empires: Ottoman","type":"MovieContentType.series","year":"2022","yearRange":"2020–2022","languages":"[]","genres":"[]","keywords":"[]",
      "description":"staring [Cem Yigit Uzümoglu, Tuba Büyüküstün]","imageUrl":"https://m.media-amazon.com/images/M/MV5BODIyNGU3OGMtNzBiYi00YTA4LTkzNjItYzBjZDgwMDUyMDg1XkEyXkFqcGdeQXVyOTkzODAxNTE@._V1_.jpg","sources":{"DataSourceType.imdbSearch":"tt9244578"},"related":{}}
''',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryIMDBSearch test', () {
    // Search for a rare movie.
    test('Run a search on IMDB that is likely to have static results',
        () async {
      final criteria = SearchCriteriaDTO().fromString('rize');
      final actualOutput =
          await QueryIMDBSearch().readList(criteria, limit: 10);
      actualOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
      final expectedOutput = expectedDTOList;
      expectedOutput.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));

      // To update expected data, uncomment the following line
      // print(actualOutput.toListOfDartJsonStrings(excludeCopyrightedData: false));

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(
          expectedOutput,
          60, // 60% of records must match
        ),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
  });
}
